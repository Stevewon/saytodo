import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import db from '../db/database.js';
import { authMiddleware } from '../middleware/auth.js';

const router = express.Router();

// Create group room
router.post('/create', authMiddleware, async (req, res) => {
  try {
    const { name, memberEmails } = req.body;
    const creatorId = req.user.userId;

    if (!name || !memberEmails || !Array.isArray(memberEmails)) {
      return res.status(400).json({ error: '그룹명과 멤버 이메일을 입력해주세요' });
    }

    const roomId = uuidv4();

    // Create room
    await db.runAsync(
      'INSERT INTO group_rooms (id, name, creator_id) VALUES (?, ?, ?)',
      [roomId, name, creatorId]
    );

    // Add creator as member
    await db.runAsync(
      'INSERT INTO group_members (id, room_id, user_id) VALUES (?, ?, ?)',
      [uuidv4(), roomId, creatorId]
    );

    // Add members by email
    for (const email of memberEmails) {
      const user = await db.getAsync(
        'SELECT id FROM users WHERE email = ?',
        [email.trim()]
      );

      if (user && user.id !== creatorId) {
        await db.runAsync(
          'INSERT OR IGNORE INTO group_members (id, room_id, user_id) VALUES (?, ?, ?)',
          [uuidv4(), roomId, user.id]
        );
      }
    }

    res.json({
      message: '그룹 채팅방 생성 완료',
      roomId,
      name,
    });
  } catch (error) {
    console.error('Create group error:', error);
    res.status(500).json({ error: '그룹 생성 실패' });
  }
});

// Get my group rooms
router.get('/my-rooms', authMiddleware, async (req, res) => {
  try {
    const rooms = await db.allAsync(
      `SELECT 
        r.id,
        r.name,
        r.created_at,
        u.nickname as creator_nickname,
        (SELECT COUNT(*) FROM group_members WHERE room_id = r.id) as member_count,
        (SELECT message FROM group_messages WHERE room_id = r.id ORDER BY created_at DESC LIMIT 1) as last_message
      FROM group_rooms r
      JOIN group_members m ON r.id = m.room_id
      JOIN users u ON r.creator_id = u.id
      WHERE m.user_id = ?
      ORDER BY r.created_at DESC`,
      [req.user.userId]
    );

    res.json(rooms);
  } catch (error) {
    console.error('Get rooms error:', error);
    res.status(500).json({ error: '그룹 목록 조회 실패' });
  }
});

// Get room details
router.get('/:roomId', authMiddleware, async (req, res) => {
  try {
    const { roomId } = req.params;

    // Check if user is member
    const membership = await db.getAsync(
      'SELECT * FROM group_members WHERE room_id = ? AND user_id = ?',
      [roomId, req.user.userId]
    );

    if (!membership) {
      return res.status(403).json({ error: '접근 권한이 없습니다' });
    }

    const room = await db.getAsync(
      'SELECT * FROM group_rooms WHERE id = ?',
      [roomId]
    );

    const members = await db.allAsync(
      `SELECT u.id, u.nickname, u.email 
       FROM group_members m
       JOIN users u ON m.user_id = u.id
       WHERE m.room_id = ?`,
      [roomId]
    );

    res.json({
      ...room,
      members,
    });
  } catch (error) {
    console.error('Get room error:', error);
    res.status(500).json({ error: '그룹 정보 조회 실패' });
  }
});

// Get room messages
router.get('/:roomId/messages', authMiddleware, async (req, res) => {
  try {
    const { roomId } = req.params;

    // Check if user is member
    const membership = await db.getAsync(
      'SELECT * FROM group_members WHERE room_id = ? AND user_id = ?',
      [roomId, req.user.userId]
    );

    if (!membership) {
      return res.status(403).json({ error: '접근 권한이 없습니다' });
    }

    const messages = await db.allAsync(
      `SELECT 
        m.*,
        u.nickname as sender_nickname
      FROM group_messages m
      JOIN users u ON m.sender_id = u.id
      WHERE m.room_id = ?
      ORDER BY m.created_at ASC`,
      [roomId]
    );

    res.json(messages);
  } catch (error) {
    console.error('Get messages error:', error);
    res.status(500).json({ error: '메시지 조회 실패' });
  }
});

// Leave group
router.delete('/:roomId/leave', authMiddleware, async (req, res) => {
  try {
    const { roomId } = req.params;

    await db.runAsync(
      'DELETE FROM group_members WHERE room_id = ? AND user_id = ?',
      [roomId, req.user.userId]
    );

    res.json({ message: '그룹에서 나갔습니다' });
  } catch (error) {
    console.error('Leave group error:', error);
    res.status(500).json({ error: '그룹 나가기 실패' });
  }
});

export default router;
