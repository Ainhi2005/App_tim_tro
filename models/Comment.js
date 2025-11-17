const { DataTypes, Op } = require('sequelize');
const { sequelize } = require('../config/database');

const Comment = sequelize.define('Comment', {
  comment_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for comments table'
  },
  listing_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing listings table'
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing users table'
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Comment content cannot be empty'
      },
      len: {
        args: [1, 2000],
        msg: 'Comment content must be between 1 and 2000 characters'
      }
    }
  },
  rating: {
    type: DataTypes.INTEGER,
    validate: {
      min: {
        args: [1],
        msg: 'Rating must be at least 1'
      },
      max: {
        args: [5],
        msg: 'Rating cannot exceed 5'
      }
    }
  },
  timestamp: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  status: {
    type:  DataTypes.STRING(20),
    defaultValue: 'pending',
    validate: {
      isIn: {
        args: [['approved', 'pending', 'rejected']],
        msg: 'Status must be approved, pending or rejected'
      }
    }
  },
  parent_comment_id: {
    type: DataTypes.INTEGER,
    comment: 'Self-referencing foreign key for reply comments'
  }
}, {
  tableName: 'comments',
  timestamps: false,
  underscored: true,
  scopes: {
    approved: {
      where: { status: 'approved' }
    },
    pending: {
      where: { status: 'pending' }
    },
    withUser: {
      include: ['user']
    },
    withReplies: {
      include: ['replies']
    },
    mainComments: {
      where: { parent_comment_id: null }
    },
    byListing: (listingId) => ({
      where: { listing_id: listingId }
    }),
    byUser: (userId) => ({
      where: { user_id: userId }
    }),
    withRating: {
      where: { rating: { [Op.ne]: null } }
    },
    recentFirst: {
      order: [['timestamp', 'DESC']]
    }
  }
});

// Instance methods
Comment.prototype.isApproved = function() {
  return this.status === 'approved';
};

Comment.prototype.isReply = function() {
  return this.parent_comment_id !== null;
};

Comment.prototype.canHaveReplies = function() {
  return this.parent_comment_id === null;
};

module.exports = Comment;