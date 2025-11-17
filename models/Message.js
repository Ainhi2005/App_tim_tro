const { DataTypes, Op } = require('sequelize');
const { sequelize } = require('../config/database');

const Message = sequelize.define('Message', {
  message_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for messages table'
  },
  sender_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing users table (sender)'
  },
  receiver_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing users table (receiver)'
  },
  listing_id: {
    type: DataTypes.INTEGER,
    comment: 'Foreign key referencing listings table'
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Message content cannot be empty'
      },
      len: {
        args: [1, 5000],
        msg: 'Message content must be between 1 and 5000 characters'
      }
    }
  },
  message_type: {
    type:  DataTypes.STRING(20),
    defaultValue: 'text',
    validate: {
      isIn: {
        args: [['text', 'image', 'file']],
        msg: 'Message type must be text, image or file'
      }
    }
  },
  timestamp: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  is_read: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  read_at: {
    type: DataTypes.DATE
  }
}, {
  tableName: 'messages',
  timestamps: false,
  underscored: true,
  hooks: {
    beforeUpdate: (message) => {
      if (message.changed('is_read') && message.is_read && !message.read_at) {
        message.read_at = new Date();
      }
    }
  },
  indexes: [
    {
      name: 'idx_messages_conversation',
      fields: ['sender_id', 'receiver_id']
    },
    {
      name: 'idx_messages_unread',
      fields: ['receiver_id', 'is_read'],
      where: { is_read: false }
    }
  ],
  scopes: {
    unread: {
      where: { is_read: false }
    },
    betweenUsers: (userId1, userId2) => ({
      where: {
        [Op.or]: [
          { sender_id: userId1, receiver_id: userId2 },
          { sender_id: userId2, receiver_id: userId1 }
        ]
      }
    }),
    byUser: (userId) => ({
      where: {
        [Op.or]: [
          { sender_id: userId },
          { receiver_id: userId }
        ]
      }
    }),
    recentFirst: {
      order: [['timestamp', 'DESC']]
    },
    withListing: {
      include: ['listing']
    }
  }
});

// Instance methods
Message.prototype.markAsRead = function() {
  this.is_read = true;
  this.read_at = new Date();
  return this.save();
};

Message.prototype.isFromUser = function(userId) {
  return this.sender_id === userId;
};

module.exports = Message;