// app.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');

const app = express();

// Middleware
app.use(helmet());
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

// Health check route - ĐẶT TRƯỚC database connection
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
app.post('/api/v1/auth/register', async (req, res) => {
  try {
    const { email, password, full_name, phone, role = 'tenant' } = req.body;
    
    console.log('Register attempt:', { email, full_name, role });

    // 1. Kiểm tra user đã tồn tại chưa
    const { User } = require('./models');
    const existingUser = await User.findOne({ where: { email } });
    
    if (existingUser) {
      return res.status(409).json({
        status: 'error',
        message: 'Email already exists'
      });
    }

    // 2. Tạo user mới (password sẽ tự động hash trong model hook)
    const newUser = await User.create({
      email,
      password_hash: password, // Sẽ được hash trong model
      full_name,
      phone,
      role
    });

    // 3. Trả về response
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

    // 1. Kiểm tra email và password
    if (!email || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide email and password'
      });
    }

    // 2. Tìm user với password
    const { User } = require('./models');
    const user = await User.scope('withPassword').findOne({ 
      where: { email } 
    });

    // 3. Kiểm tra user và password
    if (!user || !(await user.correctPassword(password))) {
      return res.status(401).json({
        status: 'error',
        message: 'Incorrect email or password'
      });
    }

    // 4. Kiểm tra trạng thái user
    if (user.status !== 'active') {
      return res.status(401).json({
        status: 'error',
        message: 'Your account has been deactivated'
      });
    }

    // 5. Tạo JWT token
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

// Start server NGAY LẬP TỨC
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🔗 Health: http://localhost:${PORT}/api/health`);
});

// Database connection - SAU KHI SERVER ĐÃ CHẠY
const { sequelize } = require('./config/database');
setTimeout(() => {
  sequelize.authenticate()
    .then(() => console.log('✅ Database connected!'))
    .catch(err => console.log('❌ Database error (but server is running):', err.message));
}, 1000);
app.use((err, req, res, next) => {
  console.error('🔥 ERROR:', err);
  res.status(500).json({ error: err.message });
});


module.exports = app;