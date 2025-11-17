const { User, UserSession } = require('../models');
const { createSendToken } = require('../utils/jwt');
const AppError = require('../utils/appError');
const { Op } = require('sequelize');

const authController = {
  // ĐĂNG KÝ
  register: async (req, res, next) => {
    try {
      const { email, password, full_name, phone, role = 'tenant' } = req.body;

      // 1) Check if user already exists
      const existingUser = await User.findOne({ where: { email } });
      if (existingUser) {
        return res.status(409).json({
          status: 'error',
          message: 'Email already exists'
        });
      }

      // 2) Create new user
      const newUser = await User.create({
        email,
        password_hash: password, // Will be hashed by model hook
        full_name,
        phone,
        role
      });

      // 3) Create user session
      await UserSession.create({
        user_id: newUser.user_id,
        token: 'temp', // Will be set properly after login
        device_info: req.headers['user-agent'] || 'Unknown',
        ip_address: req.ip || req.connection.remoteAddress,
        expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 days
      });

      // 4) Send token to client
      createSendToken(newUser, 201, res);

    } catch (error) {
      next(error);
    }
  },

  // ĐĂNG NHẬP
  login: async (req, res, next) => {
    try {
      const { email, password } = req.body;

      // 1) Check if email and password exist
      if (!email || !password) {
        return res.status(400).json({
          status: 'error',
          message: 'Please provide email and password'
        });
      }

      // 2) Check if user exists && password is correct
      const user = await User.scope('withPassword').findOne({ 
        where: { email } 
      });

      if (!user || !(await user.correctPassword(password))) {
        return res.status(401).json({
          status: 'error',
          message: 'Incorrect email or password'
        });
      }

      // 3) Check if user is active
      if (user.status !== 'active') {
        return res.status(401).json({
          status: 'error',
          message: 'Your account has been deactivated. Please contact support.'
        });
      }

      // 4) Update last login and create session
      user.last_login = new Date();
      await user.save();

      // Create or update user session
      const token = require('../utils/jwt').signToken(user.user_id);
      
      await UserSession.create({
        user_id: user.user_id,
        token,
        device_info: req.headers['user-agent'] || 'Unknown',
        ip_address: req.ip || req.connection.remoteAddress,
        expires_at: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 days
      });

      // 5) Send token to client
      createSendToken(user, 200, res);

    } catch (error) {
      next(error);
    }
  },

  // ĐĂNG XUẤT
  logout: async (req, res, next) => {
    try {
      // Get token from header
      const token = req.headers.authorization?.split(' ')[1];
      
      if (token) {
        // Delete the session
        await UserSession.destroy({ 
          where: { token } 
        });
      }

      res.status(200).json({
        status: 'success',
        message: 'Logged out successfully'
      });

    } catch (error) {
      next(error);
    }
  },

  // QUÊN MẬT KHẨU
  forgotPassword: async (req, res, next) => {
    try {
      const { email } = req.body;

      // 1) Get user based on POSTed email
      const user = await User.findOne({ where: { email } });
      if (!user) {
        return res.status(404).json({
          status: 'error',
          message: 'There is no user with that email address'
        });
      }

      // 2) Generate reset token (simplified - in real app, send email)
      const resetToken = require('crypto').randomBytes(32).toString('hex');
      const resetTokenExpires = new Date(Date.now() + 10 * 60 * 1000); // 10 minutes

      // Save reset token to user (you might want to add these fields to User model)
      // user.reset_token = resetToken;
      // user.reset_token_expires = resetTokenExpires;
      // await user.save();

      // 3) Send it to user's email (implement email service later)
      console.log(`Reset token for ${email}: ${resetToken}`); // Temporary

      res.status(200).json({
        status: 'success',
        message: 'Token sent to email!'
      });

    } catch (error) {
      next(error);
    }
  },

  // ĐỔI MẬT KHẨU
  updatePassword: async (req, res, next) => {
    try {
      const { currentPassword, newPassword } = req.body;
      const userId = req.user.user_id;

      // 1) Get user from collection
      const user = await User.scope('withPassword').findByPk(userId);

      // 2) Check if POSTed current password is correct
      if (!(await user.correctPassword(currentPassword))) {
        return res.status(401).json({
          status: 'error',
          message: 'Your current password is wrong'
        });
      }

      // 3) If so, update password
      user.password_hash = newPassword; // Will be hashed by model hook
      await user.save();

      // 4) Log user in, send JWT
      createSendToken(user, 200, res);

    } catch (error) {
      next(error);
    }
  },

  // LẤY THÔNG TIN USER HIỆN TẠI
  getMe: async (req, res, next) => {
    try {
      const user = await User.findByPk(req.user.user_id, {
        attributes: { exclude: ['password_hash'] },
        include: [
          {
            model: require('../models').Listing,
            as: 'listings',
            limit: 5,
            order: [['created_date', 'DESC']]
          },
          {
            model: require('../models').Favorite,
            as: 'favorites',
            include: [{
              model: require('../models').Listing,
              as: 'listing',
              include: [{
                model: require('../models').ListingImage,
                as: 'images',
                limit: 1
              }]
            }],
            limit: 5
          }
        ]
      });

      res.status(200).json({
        status: 'success',
        data: {
          user
        }
      });

    } catch (error) {
      next(error);
    }
  },

  // CẬP NHẬT THÔNG TIN USER
  updateMe: async (req, res, next) => {
    try {
      const { full_name, phone, avatar_url } = req.body;
      const userId = req.user.user_id;

      // Filter allowed fields
      const allowedUpdates = { full_name, phone, avatar_url };
      Object.keys(allowedUpdates).forEach(key => {
        if (allowedUpdates[key] === undefined) {
          delete allowedUpdates[key];
        }
      });

      // Update user
      const user = await User.findByPk(userId);
      await user.update(allowedUpdates);

      res.status(200).json({
        status: 'success',
        data: {
          user
        }
      });

    } catch (error) {
      next(error);
    }
  }
};

module.exports = authController;