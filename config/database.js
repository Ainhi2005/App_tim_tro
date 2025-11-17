// config/database.js
const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize(
  process.env.DB_NAME || 'trofinder_db',
  process.env.DB_USER || 'postgres',
  process.env.DB_PASSWORD || 'password',
  {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    dialect: 'postgres',
    logging: process.env.NODE_ENV === 'development' ? console.log : false,
    pool: {
      max: 10,
      min: 0,
      acquire: 30000,
      idle: 10000
    },
    define: {
      timestamps: true,
      underscored: true,
    }
  }
);

const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Kết nối PostgreSQL thành công!');
    
    // CHỈ sync trong development và chỉ khi cần
    if (process.env.NODE_ENV === 'development' && process.env.DB_SYNC === 'true') {
      console.log('🔄 Syncing database...');
      await sequelize.sync({ 
        force: false,
        alter: false // QUAN TRỌNG: tắt alter để tránh lỗi
      });
      console.log('✅ Database synced!');
    }
  } catch (error) {
    console.error('❌ Lỗi kết nối database:', error.message);
  }
};

module.exports = { sequelize, testConnection };