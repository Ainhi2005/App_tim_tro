const { sequelize } = require('../config/database');

// Import all models
const User = require('./User');
const Listing = require('./Listing');
const ListingImage = require('./ListingImage');
const Message = require('./Message');
const Comment = require('./Comment');
const Report = require('./Report');
const Notification = require('./Notification');
const Favorite = require('./Favorite');
const UserSession = require('./UserSession');
const SystemSetting = require('./SystemSetting');

// Define associations
const defineAssociations = () => {
  // User associations
  User.hasMany(Listing, { 
    foreignKey: 'landlord_id', 
    as: 'listings',
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE'
  });
  
  User.hasMany(Message, { 
    foreignKey: 'sender_id', 
    as: 'sent_messages',
    onDelete: 'CASCADE'
  });
  
  User.hasMany(Message, { 
    foreignKey: 'receiver_id', 
    as: 'received_messages',
    onDelete: 'CASCADE'
  });
  
  User.hasMany(Comment, { 
    foreignKey: 'user_id', 
    as: 'comments',
    onDelete: 'CASCADE'
  });
  
  User.hasMany(Report, { 
    foreignKey: 'reporter_id', 
    as: 'reports',
    onDelete: 'CASCADE'
  });
  
  User.hasMany(Report, { 
    foreignKey: 'resolved_by', 
    as: 'resolved_reports'
  });
  
  User.hasMany(Notification, { 
    foreignKey: 'user_id', 
    as: 'notifications',
    onDelete: 'CASCADE'
  });
  
  User.hasMany(Favorite, { 
    foreignKey: 'user_id', 
    as: 'favorites',
    onDelete: 'CASCADE'
  });
  
  User.hasMany(UserSession, { 
    foreignKey: 'user_id', 
    as: 'sessions',
    onDelete: 'CASCADE'
  });
  
  User.hasMany(SystemSetting, { 
    foreignKey: 'updated_by', 
    as: 'updated_settings'
  });

  // Listing associations
  Listing.belongsTo(User, { 
    foreignKey: 'landlord_id', 
    as: 'landlord'
  });
  
  Listing.hasMany(ListingImage, { 
    foreignKey: 'listing_id', 
    as: 'images',
    onDelete: 'CASCADE'
  });
  
  Listing.hasMany(Message, { 
    foreignKey: 'listing_id', 
    as: 'messages',
    onDelete: 'SET NULL'
  });
  
  Listing.hasMany(Comment, { 
    foreignKey: 'listing_id', 
    as: 'comments',
    onDelete: 'CASCADE'
  });
  
  Listing.hasMany(Report, { 
    foreignKey: 'target_listing_id', 
    as: 'reports'
  });
  
  Listing.hasMany(Favorite, { 
    foreignKey: 'listing_id', 
    as: 'favorited_by',
    onDelete: 'CASCADE'
  });

  // ListingImage associations
  ListingImage.belongsTo(Listing, { 
    foreignKey: 'listing_id', 
    as: 'listing'
  });

  // Message associations
  Message.belongsTo(User, { 
    foreignKey: 'sender_id', 
    as: 'sender'
  });
  
  Message.belongsTo(User, { 
    foreignKey: 'receiver_id', 
    as: 'receiver'
  });
  
  Message.belongsTo(Listing, { 
    foreignKey: 'listing_id', 
    as: 'listing'
  });

  // Comment associations
  Comment.belongsTo(Listing, { 
    foreignKey: 'listing_id', 
    as: 'listing'
  });
  
  Comment.belongsTo(User, { 
    foreignKey: 'user_id', 
    as: 'user'
  });
  
  Comment.hasMany(Comment, { 
    foreignKey: 'parent_comment_id', 
    as: 'replies',
    onDelete: 'CASCADE'
  });
  
  Comment.belongsTo(Comment, { 
    foreignKey: 'parent_comment_id', 
    as: 'parent_comment'
  });
  
  Comment.hasMany(Report, { 
    foreignKey: 'target_comment_id', 
    as: 'reports'
  });

  // Report associations
  Report.belongsTo(User, { 
    foreignKey: 'reporter_id', 
    as: 'reporter'
  });
  
  Report.belongsTo(User, { 
    foreignKey: 'resolved_by', 
    as: 'resolver'
  });
  
  Report.belongsTo(Listing, { 
    foreignKey: 'target_listing_id', 
    as: 'target_listing'
  });
  
  Report.belongsTo(Comment, { 
    foreignKey: 'target_comment_id', 
    as: 'target_comment'
  });
  
  Report.belongsTo(User, { 
    foreignKey: 'target_user_id', 
    as: 'target_user'
  });
  
  Report.belongsTo(Message, { 
    foreignKey: 'target_message_id', 
    as: 'target_message'
  });

  // Notification associations
  Notification.belongsTo(User, { 
    foreignKey: 'user_id', 
    as: 'user'
  });

  // Favorite associations (Many-to-Many between User and Listing)
  Favorite.belongsTo(User, { 
    foreignKey: 'user_id', 
    as: 'user'
  });
  
  Favorite.belongsTo(Listing, { 
    foreignKey: 'listing_id', 
    as: 'listing'
  });

  // UserSession associations
  UserSession.belongsTo(User, { 
    foreignKey: 'user_id', 
    as: 'user'
  });

  // SystemSetting associations
  SystemSetting.belongsTo(User, { 
    foreignKey: 'updated_by', 
    as: 'updater'
  });

  // Many-to-Many associations
  User.belongsToMany(Listing, {
    through: Favorite,
    foreignKey: 'user_id',
    otherKey: 'listing_id',
    as: 'favorite_listings'
  });

  Listing.belongsToMany(User, {
    through: Favorite,
    foreignKey: 'listing_id',
    otherKey: 'user_id',
    as: 'favorited_by_users'
  });
};

// Initialize associations
defineAssociations();

// Export all models and sequelize instance
module.exports = {
  sequelize,
  User,
  Listing,
  ListingImage,
  Message,
  Comment,
  Report,
  Notification,
  Favorite,
  UserSession,
  SystemSetting
};