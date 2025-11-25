const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Comment = sequelize.define('Comment', {
  comment_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  listing_id: { type: DataTypes.INTEGER, allowNull: false }, // Quan trọng: Link tới bài đăng
  user_id: { type: DataTypes.INTEGER, allowNull: false },
  content: { type: DataTypes.TEXT, allowNull: false },
  rating: { 
    type: DataTypes.INTEGER,
    validate: { min: 1, max: 5 } // Giới hạn chỉ được 1-5 sao
  },
  status: { type: DataTypes.STRING, defaultValue: 'pending' },
  timestamp: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  tableName: 'comments',
  timestamps: false,
  underscored: true
});

module.exports = Comment;