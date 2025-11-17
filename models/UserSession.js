const { DataTypes, Op } = require('sequelize');
const { sequelize } = require('../config/database');

const UserSession = sequelize.define('UserSession', {
  session_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for user sessions table'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing users table'
  },
  token: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Token cannot be empty'
      }
    }
  },
  device_info: {
    type: DataTypes.JSONB,
    defaultValue: {}
  },
  ip_address: {
    type: DataTypes.INET
  },
  expires_at: {
    type: DataTypes.DATE,
    allowNull: false,
    validate: {
      isDate: {
        msg: 'Expires at must be a valid date'
      },
      isAfter: {
        args: [new Date().toISOString()],
        msg: 'Expires at must be in the future'
      }
    }
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  last_activity: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'user_sessions',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'last_activity',
  underscored: true,
  scopes: {
    active: {
      where: {
        expires_at: { [Op.gt]: new Date() }
      }
    },
    expired: {
      where: {
        expires_at: { [Op.lte]: new Date() }
      }
    },
    byUser: (userId) => ({
      where: { user_id: userId }
    }),
    byToken: (token) => ({
      where: { token }
    }),
    recentActivity: {
      order: [['last_activity', 'DESC']]
    }
  }
});

// Instance methods
UserSession.prototype.isExpired = function() {
  return this.expires_at <= new Date();
};

UserSession.prototype.isActive = function() {
  return !this.isExpired();
};

UserSession.prototype.updateActivity = function() {
  this.last_activity = new Date();
  return this.save();
};

UserSession.prototype.extend = function(additionalTimeMs = 3600000) { // 1 hour default
  this.expires_at = new Date(this.expires_at.getTime() + additionalTimeMs);
  return this.save();
};

module.exports = UserSession;