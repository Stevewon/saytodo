import express from 'express';
import { v4 as uuidv4 } from 'uuid';
import db from '../db/database.js';
import { authMiddleware } from '../middleware/auth.js';

const router = express.Router();

// Get user by Secret QR Address
router.get('/by-sqr/:sqrAddress', authMiddleware, async (req, res) => {
  try {
    const { sqrAddress } = req.params;

    const user = await db.getAsync(
      'SELECT id, nickname, secret_qr_address FROM users WHERE secret_qr_address = ?',
      [sqrAddress]
    );

    if (!user) {
      return res.status(404).json({ error: '사용자를 찾을 수 없습니다' });
    }

    // Check if already friends
    const friendship = await db.getAsync(
      'SELECT * FROM friends WHERE user_id = ? AND friend_id = ?',
      [req.user.userId, user.id]
    );

    res.json({
      id: user.id,
      nickname: user.nickname,
      secretQRAddress: user.secret_qr_address,
      isAlreadyFriend: !!friendship,
    });
  } catch (error) {
    console.error('Get user by SQR error:', error);
    res.status(500).json({ error: '사용자 조회 실패' });
  }
});

// Add friend by Secret QR Address
router.post('/add-friend', authMiddleware, async (req, res) => {
  try {
    const { sqrAddress } = req.body;
    const myUserId = req.user.userId;

    // Find friend
    const friend = await db.getAsync(
      'SELECT * FROM users WHERE secret_qr_address = ?',
      [sqrAddress]
    );

    if (!friend) {
      return res.status(404).json({ error: '유효하지 않은 QR 코드입니다' });
    }

    if (friend.id === myUserId) {
      return res.status(400).json({ error: '자기 자신을 친구로 추가할 수 없습니다' });
    }

    // Check if already friends
    const existingFriendship = await db.getAsync(
      'SELECT * FROM friends WHERE user_id = ? AND friend_id = ?',
      [myUserId, friend.id]
    );

    if (existingFriendship) {
      return res.status(400).json({ error: '이미 친구입니다' });
    }

    // Add friendship (bidirectional)
    const friendshipId1 = uuidv4();
    const friendshipId2 = uuidv4();

    await db.runAsync(
      'INSERT INTO friends (id, user_id, friend_id, friend_nickname) VALUES (?, ?, ?, ?)',
      [friendshipId1, myUserId, friend.id, friend.nickname]
    );

    await db.runAsync(
      'INSERT INTO friends (id, user_id, friend_id, friend_nickname) VALUES (?, ?, ?, ?)',
      [friendshipId2, friend.id, myUserId, req.user.nickname]
    );

    res.json({
      message: '친구 추가 완료',
      friend: {
        id: friend.id,
        nickname: friend.nickname,
        secretQRAddress: friend.secret_qr_address,
      },
    });
  } catch (error) {
    console.error('Add friend error:', error);
    res.status(500).json({ error: '친구 추가 실패' });
  }
});

// Get my friends
router.get('/friends', authMiddleware, async (req, res) => {
  try {
    const friends = await db.allAsync(
      `SELECT 
        f.id as friendship_id,
        u.id,
        u.nickname,
        u.secret_qr_address,
        f.added_at
      FROM friends f
      JOIN users u ON f.friend_id = u.id
      WHERE f.user_id = ?
      ORDER BY f.added_at DESC`,
      [req.user.userId]
    );

    res.json(friends);
  } catch (error) {
    console.error('Get friends error:', error);
    res.status(500).json({ error: '친구 목록 조회 실패' });
  }
});

// Delete friend
router.delete('/friends/:friendId', authMiddleware, async (req, res) => {
  try {
    const { friendId } = req.params;
    const myUserId = req.user.userId;

    // Delete both directions
    await db.runAsync(
      'DELETE FROM friends WHERE user_id = ? AND friend_id = ?',
      [myUserId, friendId]
    );

    await db.runAsync(
      'DELETE FROM friends WHERE user_id = ? AND friend_id = ?',
      [friendId, myUserId]
    );

    res.json({ message: '친구 삭제 완료' });
  } catch (error) {
    console.error('Delete friend error:', error);
    res.status(500).json({ error: '친구 삭제 실패' });
  }
});

export default router;
