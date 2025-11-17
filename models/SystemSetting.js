const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const SystemSetting = sequelize.define('SystemSetting', {
  setting_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    comment: 'Primary key for system settings table'
  },
  setting_key: {
    type: DataTypes.STRING(100),
    allowNull: false,
    unique: {
      name: 'system_settings_key_unique',
      msg: 'Setting key already exists'
    },
    validate: {
      notEmpty: {
        msg: 'Setting key cannot be empty'
      },
      len: {
        args: [1, 100],
        msg: 'Setting key must be between 1 and 100 characters'
      }
    }
  },
  setting_value: {
    type: DataTypes.JSONB,
    allowNull: false,
    validate: {
      notEmpty: {
        msg: 'Setting value cannot be empty'
      }
    }
  },
  description: {
    type: DataTypes.TEXT
  },
  updated_by: {
    type: DataTypes.INTEGER,
    comment: 'Foreign key referencing users table'
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
  tableName: 'system_settings',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
  underscored: true,
  scopes: {
    byKey: (key) => ({
      where: { setting_key: key }
    }),
    withUpdater: {
      include: ['updater']
    }
  }
});

// Instance methods
SystemSetting.prototype.getValue = function() {
  return this.setting_value;
};

SystemSetting.prototype.setValue = function(newValue) {
  this.setting_value = newValue;
  return this.save();
};

SystemSetting.prototype.isBoolean = function() {
  return typeof this.setting_value === 'boolean';
};

SystemSetting.prototype.isNumber = function() {
  return typeof this.setting_value === 'number';
};

SystemSetting.prototype.isString = function() {
  return typeof this.setting_value === 'string';
};

// Static methods
SystemSetting.getByKey = function(key) {
  return this.findOne({ where: { setting_key: key } });
};

SystemSetting.getByKey = function(key) {
  return this.findOne({ where: { setting_key: key } });
};

SystemSetting.getValue = async function(key, defaultValue = null) {
  const setting = await this.findOne({ where: { setting_key: key } });
  return setting ? setting.setting_value : defaultValue;
};

SystemSetting.setValue = async function(key, value, description = null, userId = null) {
  const [setting, created] = await this.findOrCreate({
    where: { setting_key: key },
    defaults: {
      setting_value: value,
      description: description,
      updated_by: userId
    }
  });

  if (!created) {
    setting.setting_value = value;
    setting.updated_by = userId;
    if (description) setting.description = description;
    await setting.save();
  }

  return setting;
};

module.exports = SystemSetting;