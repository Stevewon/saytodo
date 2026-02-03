import express from 'express';
import { createServer } from 'http';
import { Server } from 'socket.io';
import cors from 'cors';
import { v4 as uuidv4 } from 'uuid';
import jwt from 'jsonwebtoken';
import multer from 'multer';
import path from 'path';
import { fileURLToPath } from 'url';

import { initDatabase } from './db/database.js';
import db from './db/database.js';
import authRoutes from './routes/auth.js';
import friendsRoutes from './routes/friends.js';
import groupsRoutes from './routes/groups.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  },
  maxHttpBufferSize: 10e6 // 10MB for file uploads
});

const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';

// File upload configuration
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.join(__dirname, '../public/uploads'));
  },
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${uuidv4()}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  }
});

const upload = multer({ 
  storage,
  limits: { fileSize: 10 * 1024 * 1024 } // 10MB
});

app.use(cors());
app.use(express.json());
app.use('/uploads', express.static(path.join(__dirname, '../public/uploads')));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/friends', friendsRoutes);
app.use('/api/groups', groupsRoutes);

// File upload endpoint
app.post('/api/upload', upload.single('file'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: '파일이 없습니다' });
  }

  res.json({
    fileUrl: `/uploads/${req.file.filename}`,
    fileName: req.file.originalname,
    fileType: req.file.mimetype,
    fileSize: req.file.size
  });
});

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Socket.IO connection handling
const connectedUsers = new Map(); // socketId -> userId

io.use((socket, next) => {
  const token = socket.handshake.auth.token;
  if (!token) {
    return next(new Error('Authentication error'));
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    socket.userId = decoded.userId;
    socket.userNickname = decoded.nickname;
    next();
  } catch (err) {
    next(new Error('Authentication error'));
  }
});

io.on('connection', (socket) => {
  console.log(`User connected: ${socket.userNickname} (${socket.userId})`);
  connectedUsers.set(socket.userId, socket.id);

  // Notify user is online
  socket.broadcast.emit('user-online', { userId: socket.userId });

  // Join direct chat room (for 1:1 messages)
  socket.on('join-direct-chat', ({ friendId }) => {
    const roomId = [socket.userId, friendId].sort().join('-');
    socket.join(roomId);
    console.log(`${socket.userNickname} joined direct chat with ${friendId}`);
  });

  // Send direct message (1:1)
  socket.on('send-direct-message', async ({ receiverId, message, fileUrl, fileName, fileType }) => {
    try {
      const messageId = uuidv4();
      
      await db.runAsync(
        `INSERT INTO direct_messages (id, sender_id, receiver_id, message, file_url, file_name, file_type) 
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [messageId, socket.userId, receiverId, message, fileUrl, fileName, fileType]
      );

      const newMessage = {
        id: messageId,
        sender_id: socket.userId,
        sender_nickname: socket.userNickname,
        receiver_id: receiverId,
        message,
        file_url: fileUrl,
        file_name: fileName,
        file_type: fileType,
        created_at: new Date().toISOString(),
        is_read: 0
      };

      const roomId = [socket.userId, receiverId].sort().join('-');
      io.to(roomId).emit('direct-message', newMessage);

      // Send to receiver if online
      const receiverSocketId = connectedUsers.get(receiverId);
      if (receiverSocketId) {
        io.to(receiverSocketId).emit('new-message-notification', {
          from: socket.userId,
          fromNickname: socket.userNickname,
          message: message || '파일을 보냈습니다'
        });
      }
    } catch (error) {
      console.error('Send direct message error:', error);
      socket.emit('error', { message: '메시지 전송 실패' });
    }
  });

  // Join group room
  socket.on('join-group', ({ roomId }) => {
    socket.join(`group-${roomId}`);
    console.log(`${socket.userNickname} joined group ${roomId}`);
  });

  // Send group message
  socket.on('send-group-message', async ({ roomId, message, fileUrl, fileName, fileType }) => {
    try {
      const messageId = uuidv4();
      
      await db.runAsync(
        `INSERT INTO group_messages (id, room_id, sender_id, message, file_url, file_name, file_type) 
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [messageId, roomId, socket.userId, message, fileUrl, fileName, fileType]
      );

      const newMessage = {
        id: messageId,
        room_id: roomId,
        sender_id: socket.userId,
        sender_nickname: socket.userNickname,
        message,
        file_url: fileUrl,
        file_name: fileName,
        file_type: fileType,
        created_at: new Date().toISOString()
      };

      io.to(`group-${roomId}`).emit('group-message', newMessage);
    } catch (error) {
      console.error('Send group message error:', error);
      socket.emit('error', { message: '메시지 전송 실패' });
    }
  });

  // WebRTC signaling for voice/video calls
  socket.on('call-user', ({ to, offer, callType }) => {
    const receiverSocketId = connectedUsers.get(to);
    if (receiverSocketId) {
      io.to(receiverSocketId).emit('incoming-call', {
        from: socket.userId,
        fromNickname: socket.userNickname,
        offer,
        callType // 'audio' or 'video'
      });
    }
  });

  socket.on('call-answer', ({ to, answer }) => {
    const receiverSocketId = connectedUsers.get(to);
    if (receiverSocketId) {
      io.to(receiverSocketId).emit('call-answered', {
        from: socket.userId,
        answer
      });
    }
  });

  socket.on('ice-candidate', ({ to, candidate }) => {
    const receiverSocketId = connectedUsers.get(to);
    if (receiverSocketId) {
      io.to(receiverSocketId).emit('ice-candidate', {
        from: socket.userId,
        candidate
      });
    }
  });

  socket.on('end-call', ({ to }) => {
    const receiverSocketId = connectedUsers.get(to);
    if (receiverSocketId) {
      io.to(receiverSocketId).emit('call-ended', {
        from: socket.userId
      });
    }
  });

  // Mark messages as read
  socket.on('mark-as-read', async ({ senderId }) => {
    try {
      await db.runAsync(
        'UPDATE direct_messages SET is_read = 1 WHERE sender_id = ? AND receiver_id = ?',
        [senderId, socket.userId]
      );

      const senderSocketId = connectedUsers.get(senderId);
      if (senderSocketId) {
        io.to(senderSocketId).emit('messages-read', { by: socket.userId });
      }
    } catch (error) {
      console.error('Mark as read error:', error);
    }
  });

  // Disconnect
  socket.on('disconnect', () => {
    console.log(`User disconnected: ${socket.userNickname} (${socket.userId})`);
    connectedUsers.delete(socket.userId);
    socket.broadcast.emit('user-offline', { userId: socket.userId });
  });
});

// Initialize database and start server
const PORT = process.env.PORT || 3001;

initDatabase().then(() => {
  httpServer.listen(PORT, '0.0.0.0', () => {
    console.log(`🚀 Securet QR Chat Server running on port ${PORT}`);
  });
}).catch(err => {
  console.error('Failed to initialize database:', err);
  process.exit(1);
});
