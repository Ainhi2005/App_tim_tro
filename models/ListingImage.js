const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const ListingImage = sequelize.define('ListingImage', {
  image_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for listing images table'
  },
  listing_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing listings table'
  },
  image_url: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Image URL cannot be empty'
      },
      isUrl: {
        msg: 'Image URL must be a valid URL',
        protocols: ['http', 'https'],
        require_protocol: true
      }
    }
  },
  description: {
    type: DataTypes.TEXT,
    validate: {
      len: {
        args: [0, 500],
        msg: 'Description cannot exceed 500 characters'
      }
    }
  },
  order_index: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
    validate: {
      min: {
        args: [0],
        msg: 'Order index cannot be negative'
      }
    }
  }
}, {
  tableName: 'listing_images',
  timestamps: true,
  underscored: true,
  createdAt: 'created_at', // Map đúng tên cột trong DB
  updatedAt: false,        // ⛔️ Tắt updated_at vì DB không có cột này
  scopes: {
    byListing: (listingId) => ({
      where: { listing_id: listingId }
    }),
    ordered: {
      order: [['order_index', 'ASC']]
    },
    primaryFirst: {
      order: [['order_index', 'ASC'], ['image_id', 'ASC']]
    }
  }
});

module.exports = ListingImage;