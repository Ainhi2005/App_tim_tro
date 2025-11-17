const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');
const bcrypt = require('bcryptjs');

const User = sequelize.define('User', {
  user_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for users table'
  },
  email: {
    type: DataTypes.STRING(255),
    allowNull: false,
    unique: {
      name: 'users_email_unique',
      msg: 'Email already exists'
    },
    validate: {
      isEmail: {
        msg: 'Please provide a valid email address'
      },
      notEmpty: {
        msg: 'Email cannot be empty'
      },
      len: {
        args: [5, 255],
        msg: 'Email must be between 5 and 255 characters'
      }
    }
  },
  phone: {
    type: DataTypes.STRING(20),
    validate: {
      is: {
        args: /^[0-9+\-\s()]{10,20}$/,
        msg: 'Please provide a valid phone number'
      }
    }
  },
  full_name: {
    type: DataTypes.STRING(100),
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Full name cannot be empty'
      },
      len: {
        args: [1, 100],
        msg: 'Full name must be between 1 and 100 characters'
      }
    }
  },
  password_hash: {
    type: DataTypes.STRING(255),
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Password hash cannot be empty'
      }
    }
  },
  role: {
  type: DataTypes.STRING(20),
  allowNull: false,
  defaultValue: 'tenant',
  validate: {
    isIn: {
      args: [['tenant', 'landlord', 'admin']],
      msg: 'Role must be tenant, landlord or admin'
    }
  }
},
status: {
  type: DataTypes.STRING(20),
  defaultValue: 'active',
  validate: {
    isIn: {
      args: [['active', 'inactive', 'banned']],
      msg: 'Status must be active, inactive or banned'
    }
  }
},
  avatar_url: {
    type: DataTypes.TEXT,
    validate: {
      isUrl: {
        msg: 'Avatar URL must be a valid URL',
        protocols: ['http', 'https'],
        require_protocol: true
      }
    }
  },
  registration_date: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'users',
  timestamps: true,
  createdAt: 'registration_date',
  updatedAt: 'updated_at',
  underscored: true,
  hooks: {
    beforeValidate: (user) => {
      if (user.email) {
        user.email = user.email.toLowerCase().trim();
      }
    },
    beforeCreate: async (user) => {
      if (user.password_hash) {
        user.password_hash = await bcrypt.hash(user.password_hash, 12);
      }
    },
    beforeUpdate: async (user) => {
      if (user.changed('password_hash') && user.password_hash) {
        user.password_hash = await bcrypt.hash(user.password_hash, 12);
      }
    }
  },
  defaultScope: {
    attributes: { exclude: ['password_hash'] }
  },
  scopes: {
    withPassword: {
      attributes: { include: ['password_hash'] }
    },
    active: {
      where: { status: 'active' }
    },
    byRole: (role) => ({
      where: { role }
    })
  }
});

// Instance methods
User.prototype.correctPassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password_hash);
};

User.prototype.isActive = function() {
  return this.status === 'active';
};

User.prototype.isAdmin = function() {
  return this.role === 'admin';
};

User.prototype.isLandlord = function() {
  return this.role === 'landlord';
};

User.prototype.toJSON = function() {
  const values = { ...this.get() };
  delete values.password_hash;
  return values;
};

// Static methods
User.findByEmail = function(email) {
  return this.findOne({ 
    where: { email: email.toLowerCase().trim() } 
  });
};

User.findActiveById = function(userId) {
  return this.findOne({
    where: { 
      user_id: userId,
      status: 'active'
    }
  });
};

module.exports = User;