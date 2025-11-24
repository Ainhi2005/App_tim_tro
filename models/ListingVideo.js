const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const ListingVideo = sequelize.define('ListingVideo', {
  video_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  listing_id: { type: DataTypes.INTEGER, allowNull: false },
  video_url: { type: DataTypes.TEXT, allowNull: false },
  thumbnail_url: { type: DataTypes.TEXT },
  description: { type: DataTypes.TEXT },
  duration_seconds: { type: DataTypes.INTEGER },
  order_index: { type: DataTypes.INTEGER, defaultValue: 0 },
  created_at: { type: DataTypes.DATE, defaultValue: DataTypes.NOW }
}, {
  tableName: 'listing_videos',
  timestamps: false, 
  underscored: true
});

module.exports = ListingVideo;