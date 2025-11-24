const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Favorite = sequelize.define('Favorite', {
  favorite_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  user_id: { type: DataTypes.INTEGER, allowNull: false },
  listing_id: { type: DataTypes.INTEGER, allowNull: false }, // Quan trọng: Link tới bài đăng
  created_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  tableName: 'favorites',
  timestamps: false,
  underscored: true
});

module.exports = Favorite;