const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Favorite = sequelize.define('Favorite', {
  favorite_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for favorites table'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing users table'
  },
  listing_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing listings table'
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'favorites',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: false,
  underscored: true,
  indexes: [
    {
      unique: true,
      fields: ['user_id', 'listing_id']
    }
  ],
  scopes: {
    byUser: (userId) => ({
      where: { user_id: userId }
    }),
    byListing: (listingId) => ({
      where: { listing_id: listingId }
    }),
    withListing: {
      include: ['listing']
    },
    recent: {
      order: [['created_at', 'DESC']]
    }
  }
});

module.exports = Favorite;