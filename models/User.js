// models/User.js
const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const User = sequelize.define('User', {
  user_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  full_name: { type: DataTypes.STRING, allowNull: false },
  email: { type: DataTypes.STRING, allowNull: false, unique: true },
  password_hash: { type: DataTypes.STRING, allowNull: false },
  role: { type: DataTypes.STRING, defaultValue: 'tenant' },
  status: { type: DataTypes.STRING, defaultValue: 'active' },
  phone: { type: DataTypes.STRING, allowNull: true }
}, {
  tableName: 'users',
  timestamps: true,
  createdAt: 'registration_date',
  updatedAt: false,
  underscored: true,
  scopes: {
    withPassword: { attributes: { include: ['password_hash'] } }
  }
});

User.prototype.correctPassword = async function(candidatePassword) {
  return candidatePassword === this.password_hash;
};

module.exports = User; // ⛔️ TUYỆT ĐỐI KHÔNG CÓ DẤU {}