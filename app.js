// app.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const { Op } = require('sequelize'); 

// Import Routes
const roomRoutes = require('./routes/roomRoutes');
const videoRoutes = require('./routes/videoRoutes');
const favoriteRoutes = require('./routes/favoriteRoutes');
const commentRoutes = require('./routes/commentRoutes');

const app = express();

// ==================== MIDDLEWARE ====================
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// ==================== MOUNT ROUTES ====================
app.use('/api/v1/rooms', roomRoutes); 
app.use('/api/v1/videos', videoRoutes); 
app.use('/api/v1/favorites', favoriteRoutes);
app.use('/api/v1/comments', commentRoutes);

// Health check route
app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'success',
    message: 'Server is running!',
    timestamp: new Date().toISOString()
  });
});

app.post('/api/test/register', (req, res) => {
  res.json({
    status: 'success',
    message: 'Direct route works!',
    body: req.body
  });
});

// ==================== AUTHENTICATION ROUTES ====================
// (Lưu ý: Tốt nhất nên tách ra authRoutes.js và authController.js, nhưng tạm thời giữ ở đây theo code cũ của bạn)

app.post('/api/v1/auth/register', async (req, res) => {
  try {
    const { email, password, full_name, phone, role = 'tenant' } = req.body;
    
    console.log('Register attempt:', { email, full_name, role });

    // Gọi User từ models/index.js để đảm bảo Association hoạt động
    const { User } = require('./models'); 
    const existingUser = await User.findOne({ where: { email } });
    
    if (existingUser) {
      return res.status(409).json({
        status: 'error',
        message: 'Email already exists'
      });
    }

    const newUser = await User.create({
      email,
      password_hash: password, 
      full_name,
      phone,
      role
    });

    res.status(201).json({
      status: 'success',
      message: 'User registered successfully!',
      data: {
        user: {
          user_id: newUser.user_id,
          email: newUser.email,
          full_name: newUser.full_name,
          phone: newUser.phone,
          role: newUser.role,
          status: newUser.status,
          registration_date: newUser.registration_date
        }
      }
    });

  } catch (error) {
    console.error('Register error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Registration failed: ' + error.message
    });
  }
});

app.post('/api/v1/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    console.log('Login attempt:', { email });

    if (!email || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide email and password'
      });
    }

    const { User } = require('./models');
    // Scope 'withPassword' cần được định nghĩa trong User model để lấy password hash
    const user = await User.scope('withPassword').findOne({ 
      where: { email } 
    });

    // Kiểm tra password (hàm correctPassword cần có trong User model)
    if (!user || !(await user.correctPassword(password))) {
      return res.status(401).json({
        status: 'error',
        message: 'Incorrect email or password'
      });
    }

    if (user.status !== 'active') {
      return res.status(401).json({
        status: 'error',
        message: 'Your account has been deactivated'
      });
    }

    // Tạo JWT token
    const { createSendToken } = require('./utils/jwt'); 
    createSendToken(user, 200, res);

  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({
      status: 'error',
      message: 'Login failed: ' + error.message
    });
  }
});

// ==================== ERROR HANDLING ====================

// 404 handler (Phải đứng SAU tất cả routes)
app.use((req, res) => {
  res.status(404).json({
    status: 'error',
    message: `Route ${req.originalUrl} not found`
  });
});

// Global Error Handler (Phải đứng CUỐI CÙNG)
app.use((err, req, res, next) => {
  console.error('🔥 ERROR:', err);
  res.status(500).json({ 
    status: 'error',
    message: 'Internal server error'
  });
});

// Chỉ export app, KHÔNG listen port ở đây
module.exports = app;