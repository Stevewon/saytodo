import { io, Socket } from 'socket.io-client';
import { useAuthStore } from '../store/authStore';

let socket: Socket | null = null;

export const initSocket = () => {
  const token = useAuthStore.getState().token;
  
  if (!token) {
    console.error('No auth token for socket connection');
    return null;
  }

  if (socket?.connected) {
    return socket;
  }

  const socketUrl = import.meta.env.VITE_API_URL || '/';

  socket = io(socketUrl, {
    auth: { token },
    transports: ['websocket', 'polling'],
    reconnection: true,
    reconnectionDelay: 1000,
    reconnectionAttempts: 5,
  });

  socket.on('connect', () => {
    console.log('Socket connected');
  });

  socket.on('disconnect', (reason) => {
    console.log('Socket disconnected:', reason);
  });

  socket.on('connect_error', (error) => {
    console.error('Socket connection error:', error);
  });

  return socket;
};

export const getSocket = () => socket;

export const disconnectSocket = () => {
  if (socket) {
    socket.disconnect();
    socket = null;
  }
};
