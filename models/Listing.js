const { DataTypes, Op } = require('sequelize');
const { sequelize } = require('../config/database');

const Listing = sequelize.define('Listing', {
  listing_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for listings table'
  },
  landlord_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing users table'
  },
  title: {
    type: DataTypes.STRING(255),
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Title cannot be empty'
      },
      len: {
        args: [1, 255],
        msg: 'Title must be between 1 and 255 characters'
      }
    }
  },
  description: {
    type: DataTypes.TEXT,
    validate: {
      len: {
        args: [0, 5000],
        msg: 'Description cannot exceed 5000 characters'
      }
    }
  },
  price: {
    type: DataTypes.DECIMAL(12, 2),
    allowNull: false,
    validate: {
      min: {
        args: [0],
        msg: 'Price must be greater than or equal to 0'
      },
      isDecimal: {
        msg: 'Price must be a valid decimal number'
      }
    },
    get() {
      const value = this.getDataValue('price');
      return value ? parseFloat(value) : null;
    }
  },
  area: {
    type: DataTypes.DECIMAL(6, 2),
    validate: {
      min: {
        args: [0],
        msg: 'Area must be greater than 0'
      }
    },
    get() {
      const value = this.getDataValue('area');
      return value ? parseFloat(value) : null;
    }
  },
  address: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Address cannot be empty'
      }
    }
  },
  ward: {
    type: DataTypes.STRING(100)
  },
  district: {
    type: DataTypes.STRING(100)
  },
  city: {
    type: DataTypes.STRING(100)
  },
  latitude: {
    type: DataTypes.DECIMAL(10, 8),
    validate: {
      min: {
        args: [-90],
        msg: 'Latitude must be between -90 and 90'
      },
      max: {
        args: [90],
        msg: 'Latitude must be between -90 and 90'
      }
    },
    get() {
      const value = this.getDataValue('latitude');
      return value ? parseFloat(value) : null;
    }
  },
  longitude: {
    type: DataTypes.DECIMAL(11, 8),
    validate: {
      min: {
        args: [-180],
        msg: 'Longitude must be between -180 and 180'
      },
      max: {
        args: [180],
        msg: 'Longitude must be between -180 and 180'
      }
    },
    get() {
      const value = this.getDataValue('longitude');
      return value ? parseFloat(value) : null;
    }
  },
  status: {
  type: DataTypes.STRING(20),
  defaultValue: 'pending',
  validate: {
    isIn: {
      args: [['active', 'inactive', 'pending', 'rejected', 'expired']],
      msg: 'Invalid status value'
    }
  }
},
  expiry_date: {
    type: DataTypes.DATE
  },
  created_date: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  updated_date: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'listings',
  timestamps: true,
  createdAt: 'created_date',
  updatedAt: 'updated_date',
  underscored: true,
  validate: {
    bothCoordsOrNone() {
      if ((this.latitude === null) !== (this.longitude === null)) {
        throw new Error('Either both latitude and longitude, or neither!');
      }
    },
    expiryDateAfterCreate() {
      if (this.expiry_date && this.expiry_date <= this.created_date) {
        throw new Error('Expiry date must be after creation date');
      }
    }
  },
  indexes: [
    {
      name: 'idx_listings_status_price',
      fields: ['status', 'price']
    },
    {
      name: 'idx_listings_city_district',
      fields: ['city', 'district']
    }
  ],
  scopes: {
    active: {
      where: { 
        status: 'active',
        [Op.or]: [
          { expiry_date: null },
          { expiry_date: { [Op.gt]: new Date() } }
        ]
      }
    },
    pending: {
      where: { status: 'pending' }
    },
    expired: {
      where: {
        status: 'expired',
        expiry_date: { [Op.lte]: new Date() }
      }
    },
    withLandlord: {
      include: ['landlord']
    },
    withImages: {
      include: ['images']
    },
    inCity: (city) => ({
      where: { city }
    }),
    inDistrict: (district) => ({
      where: { district }
    }),
    priceRange: (minPrice, maxPrice) => ({
      where: {
        price: {
          [Op.between]: [minPrice, maxPrice]
        }
      }
    }),
    areaRange: (minArea, maxArea) => ({
      where: {
        area: {
          [Op.between]: [minArea, maxArea]
        }
      }
    })
  }
});

// Instance methods
Listing.prototype.isActive = function() {
  return this.status === 'active' && 
    (!this.expiry_date || this.expiry_date > new Date());
};

Listing.prototype.isExpired = function() {
  return this.expiry_date && this.expiry_date <= new Date();
};

Listing.prototype.getPrimaryImage = function() {
  if (this.images && this.images.length > 0) {
    const sortedImages = this.images.sort((a, b) => a.order_index - b.order_index);
    return sortedImages[0].image_url;
  }
  return null;
};

module.exports = Listing;