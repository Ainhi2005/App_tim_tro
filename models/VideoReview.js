// models/VideoReview.js
const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database'); 

const VideoReview = sequelize.define('VideoReview', {
  review_id: { type: DataTypes.UUID, defaultValue: DataTypes.UUIDV4, primaryKey: true, field: 'id' },
  title: { type: DataTypes.STRING(255), allowNull: false },
  author_name: { type: DataTypes.STRING(100), allowNull: false },
  location: { type: DataTypes.STRING(100), allowNull: false },
  author_avatar_url: { type: DataTypes.TEXT, allowNull: false },
  thumbnail_url: { type: DataTypes.TEXT, allowNull: false },
  video_url: { type: DataTypes.TEXT, allowNull: false },
  like_count: { type: DataTypes.INTEGER, defaultValue: 0 },
  comment_count: { type: DataTypes.INTEGER, defaultValue: 0 },
  share_count: { type: DataTypes.INTEGER, defaultValue: 0 },
  listing_id: { type: DataTypes.INTEGER, allowNull: false }, 
  status: { type: DataTypes.STRING(20), defaultValue: 'active' },
  user_id: { type: DataTypes.INTEGER, allowNull: true } // Thêm user_id để link với bảng User
}, {
  tableName: 'video_reviews',
  timestamps: true,
  underscored: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at'
});

VideoReview.prototype.toJSON = function() {
  const values = Object.assign({}, this.get());
  values.id = values.review_id; delete values.review_id;
  // map camelCase here if needed
  return values;
};

module.exports = VideoReview; // ⛔️ TUYỆT ĐỐI KHÔNG CÓ DẤU {}