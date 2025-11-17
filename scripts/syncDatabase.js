require('dotenv').config();
const { sequelize } = require('../models');
const { User, SystemSetting } = require('../models');
const bcrypt = require('bcryptjs');

const safeSync = async () => {
  try {
    console.log('🔄 Starting safe database synchronization...');
    
    // Chỉ tạo bảng mới nếu chưa tồn tại
    await sequelize.sync({ 
      force: false,
      alter: false // QUAN TRỌNG: không alter bảng cũ
    });
    
    console.log('✅ Database checked successfully!');
    
    // Kiểm tra và tạo admin user
    const adminExists = await User.findOne({ 
      where: { email: 'admin@trofinder.com' } 
    });
    
    if (!adminExists) {
      const hashedPassword = await bcrypt.hash('admin123', 12);
      await User.create({
        email: 'admin@trofinder.com',
        phone: '0123456789',
        full_name: 'System Administrator',
        password_hash: hashedPassword,
        role: 'admin',
        status: 'active'
      });
      console.log('✅ Default admin user created!');
    } else {
      console.log('ℹ️  Admin user already exists');
    }
    
    console.log('🎉 Safe sync completed!');
    
  } catch (error) {
    console.error('❌ Safe sync failed:');
    console.error(error.message);
  } finally {
    await sequelize.close();
  }
};

safeSync();