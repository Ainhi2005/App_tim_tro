const { DataTypes, Op } = require('sequelize');
const { sequelize } = require('../config/database');

const Report = sequelize.define('Report', {
  report_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for reports table'
  },
  reporter_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    comment: 'Foreign key referencing users table (reporter)'
  },
  report_type: {
    type: DataTypes.ENUM('listing', 'comment', 'user', 'message'),
    allowNull: false,
    validate: {
      isIn: {
        args: [['listing', 'comment', 'user', 'message']],
        msg: 'Report type must be listing, comment, user or message'
      }
    }
  },
  target_listing_id: {
    type: DataTypes.INTEGER,
    comment: 'Foreign key referencing listings table'
  },
  target_comment_id: {
    type: DataTypes.INTEGER,
    comment: 'Foreign key referencing comments table'
  },
  target_user_id: {
    type: DataTypes.INTEGER,
    comment: 'Foreign key referencing users table'
  },
  target_message_id: {
    type: DataTypes.INTEGER,
    comment: 'Foreign key referencing messages table'
  },
  reason: {
    type: DataTypes.TEXT,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Reason cannot be empty'
      },
      len: {
        args: [1, 1000],
        msg: 'Reason must be between 1 and 1000 characters'
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
  evidence: {
    type: DataTypes.JSONB,
    defaultValue: {}
  },
  status: {
    type: DataTypes.ENUM('pending', 'investigating', 'resolved', 'rejected'),
    defaultValue: 'pending',
    validate: {
      isIn: {
        args: [['pending', 'investigating', 'resolved', 'rejected']],
        msg: 'Invalid status value'
      }
    }
  },
  priority: {
    type:  DataTypes.STRING(20),
    defaultValue: 'medium',
    validate: {
      isIn: {
        args: [['low', 'medium', 'high', 'urgent']],
        msg: 'Priority must be low, medium, high or urgent'
      }
    }
  },
  admin_notes: {
    type: DataTypes.JSONB,
    defaultValue: {}
  },
  resolved_by: {
    type: DataTypes.INTEGER,
    comment: 'Foreign key referencing users table (admin who resolved)'
  },
  resolved_at: {
    type: DataTypes.DATE
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  updated_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'reports',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  underscored: true,
  validate: {
    exactlyOneTarget() {
      const targets = [
        this.target_listing_id,
        this.target_comment_id,
        this.target_user_id,
        this.target_message_id
      ].filter(target => target !== null);
      
      if (targets.length !== 1) {
        throw new Error('Exactly one target must be specified for report');
      }
    },
    targetMatchesType() {
      const typeTargetMap = {
        'listing': this.target_listing_id,
        'comment': this.target_comment_id,
        'user': this.target_user_id,
        'message': this.target_message_id
      };
      
      if (!typeTargetMap[this.report_type]) {
        throw new Error(`Target for report type '${this.report_type}' must be set`);
      }
    }
  },
  hooks: {
    beforeUpdate: (report) => {
      if (report.changed('status') && report.status === 'resolved' && !report.resolved_at) {
        report.resolved_at = new Date();
      }
    }
  },
  scopes: {
    pending: {
      where: { status: 'pending' }
    },
    resolved: {
      where: { status: 'resolved' }
    },
    byType: (type) => ({
      where: { report_type: type }
    }),
    byPriority: (priority) => ({
      where: { priority }
    }),
    highPriority: {
      where: { 
        priority: { [Op.in]: ['high', 'urgent'] } 
      }
    },
    withReporter: {
      include: ['reporter']
    },
    withResolver: {
      include: ['resolver']
    },
    recentFirst: {
      order: [['created_at', 'DESC']]
    }
  }
});

// Instance methods
Report.prototype.resolve = function(adminId, notes = {}) {
  this.status = 'resolved';
  this.resolved_by = adminId;
  this.resolved_at = new Date();
  this.admin_notes = notes;
  return this.save();
};

Report.prototype.isResolved = function() {
  return this.status === 'resolved';
};

Report.prototype.isHighPriority = function() {
  return ['high', 'urgent'].includes(this.priority);
};

Report.prototype.getTargetId = function() {
  const targetMap = {
    'listing': this.target_listing_id,
    'comment': this.target_comment_id,
    'user': this.target_user_id,
    'message': this.target_message_id
  };
  return targetMap[this.report_type];
};

module.exports = Report;