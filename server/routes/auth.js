import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import QRCode from 'qrcode';
import db from '../db/database.js';

const router = express.Router();
const JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key-change-in-production';

// Register
router.post('/register', async (req, res) => {
  try {
    const { email, password, nickname, securetQRAddress } = req.body;

    if (!email || !password || !nickname || !securetQRAddress) {
      return res.status(400).json({ error: '모든 필드를 입력해주세요' });
    }

    // Validate Securet QR Address format (URL format)
    try {
      const url = new URL(securetQRAddress);
      if (!url.hostname.includes('securet.kr') || !url.searchParams.has('token')) {
        return res.status(400).json({ error: '유효한 시큐렛 QR 주소가 아닙니다' });
      }
    } catch (e) {
      return res.status(400).json({ error: '시큐렛 QR 주소 형식이 올바르지 않습니다 (URL 형식이어야 합니다)' });
    }

    // Check if email exists
    const existingUser = await db.getAsync(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (existingUser) {
      return res.status(400).json({ error: '이미 존재하는 이메일입니다' });
    }

    // Check if Securet QR Address exists
    const existingQR = await db.getAsync(
      'SELECT * FROM users WHERE secret_qr_address = ?',
      [securetQRAddress]
    );

    if (existingQR) {
      return res.status(400).json({ error: '이미 사용 중인 시큐렛 QR 주소입니다' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    const userId = uuidv4();

    // Generate QR code as base64 (using the full URL)
    const qrCodeBase64 = await QRCode.toDataURL(securetQRAddress, {
      width: 300,
      margin: 2,
      color: {
        dark: '#4f46e5',
        light: '#ffffff',
      },
    });

    // Insert user
    await db.runAsync(
      `INSERT INTO users (id, email, password, nickname, secret_qr_address, qr_code) 
       VALUES (?, ?, ?, ?, ?, ?)`,
      [userId, email, hashedPassword, nickname, securetQRAddress, qrCodeBase64]
    );

    // Generate JWT token
    const token = jwt.sign(
      { userId, email, nickname, secretQRAddress: securetQRAddress },
      JWT_SECRET,
      { expiresIn: '30d' }
    );

    res.json({
      message: '회원가입 성공',
      token,
      user: {
        id: userId,
        email,
        nickname,
        secretQRAddress: securetQRAddress,
        qrCode: qrCodeBase64,
      },
    });
  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({ error: '회원가입 실패' });
  }
});

// Login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: '이메일과 비밀번호를 입력해주세요' });
    }

    // Find user
    const user = await db.getAsync(
      'SELECT * FROM users WHERE email = ?',
      [email]
    );

    if (!user) {
      return res.status(401).json({ error: '이메일 또는 비밀번호가 올바르지 않습니다' });
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, user.password);

    if (!isValidPassword) {
      return res.status(401).json({ error: '이메일 또는 비밀번호가 올바르지 않습니다' });
    }

    // Generate JWT token
    const token = jwt.sign(
      { 
        userId: user.id, 
        email: user.email, 
        nickname: user.nickname,
        secretQRAddress: user.secret_qr_address 
      },
      JWT_SECRET,
      { expiresIn: '30d' }
    );

    res.json({
      message: '로그인 성공',
      token,
      user: {
        id: user.id,
        email: user.email,
        nickname: user.nickname,
        secretQRAddress: user.secret_qr_address,
        qrCode: user.qr_code,
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ error: '로그인 실패' });
  }
});

// Get my profile
router.get('/me', async (req, res) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];

    if (!token) {
      return res.status(401).json({ error: '인증 토큰이 없습니다' });
    }

    const decoded = jwt.verify(token, JWT_SECRET);
    const user = await db.getAsync(
      'SELECT id, email, nickname, secret_qr_address, qr_code, created_at FROM users WHERE id = ?',
      [decoded.userId]
    );

    if (!user) {
      return res.status(404).json({ error: '사용자를 찾을 수 없습니다' });
    }

    res.json({
      id: user.id,
      email: user.email,
      nickname: user.nickname,
      secretQRAddress: user.secret_qr_address,
      qrCode: user.qr_code,
      createdAt: user.created_at,
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(401).json({ error: '인증 실패' });
  }
});

export default router;
