const { DataTypes, Op } = require('sequelize');
const { sequelize } = require('../config/database');

const Notification = sequelize.define('Notification', {
  notification_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for notifications table'
  },
  user_id: {
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
  message: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Message cannot be empty'
      }
    }
  },
  notification_type: {
    type:  DataTypes.STRING(20),
    defaultValue: 'info',
    validate: {
      isIn: {
        args: [['info', 'warning', 'success', 'error', 'message', 'comment', 'listing']],
        msg: 'Invalid notification type'
      }
    }
  },
  related_entity_type: {
    type: DataTypes.STRING(20)
  },
  related_entity_id: {
    type: DataTypes.INTEGER
  },
  is_read: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  read_at: {
    type: DataTypes.DATE
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'notifications',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: false,
  underscored: true,
  hooks: {
    beforeUpdate: (notification) => {
      if (notification.changed('is_read') && notification.is_read && !notification.read_at) {
        notification.read_at = new Date();
      }
    }
  },
  scopes: {
    unread: {
      where: { is_read: false }
    },
    read: {
      where: { is_read: true }
    },
    byUser: (userId) => ({
      where: { user_id: userId }
    }),
    byType: (type) => ({
      where: { notification_type: type }
    }),
    recent: {
      order: [['created_at', 'DESC']],
      limit: 50
    },
    unreadCount: {
      attributes: [
        'user_id',
        [sequelize.fn('COUNT', sequelize.col('notification_id')), 'unread_count']
      ],
      where: { is_read: false },
      group: ['user_id']
    }
  }
});

// Instance methods
Notification.prototype.markAsRead = function() {
  this.is_read = true;
  this.read_at = new Date();
  return this.save();
};

Notification.prototype.markAsUnread = function() {
  this.is_read = false;
  this.read_at = null;
  return this.save();
};

Notification.prototype.isRecent = function(minutes = 60) {
  const recentTime = new Date(Date.now() - minutes * 60 * 1000);
  return this.created_at > recentTime;
};

module.exports = Notification;