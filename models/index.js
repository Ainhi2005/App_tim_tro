const { sequelize } = require('../config/database');

// Import Models
const User = require('./User');
const Listing = require('./Listing'); // Đây là file Listing xịn của bạn
const ListingVideo = require('./ListingVideo');
const ListingImage = require('./ListingImage');
const Comment = require('./Comment');
const Favorite = require('./Favorite');

// --- THIẾT LẬP QUAN HỆ (ASSOCIATIONS) ---

// 1. Listing & Media (Quan hệ 1-N)
Listing.hasMany(ListingVideo, { foreignKey: 'listing_id', as: 'videos' });
ListingVideo.belongsTo(Listing, { foreignKey: 'listing_id', as: 'listing' });

Listing.hasMany(ListingImage, { foreignKey: 'listing_id', as: 'images' }); // Khớp với scope 'withImages' của bạn
ListingImage.belongsTo(Listing, { foreignKey: 'listing_id', as: 'listing' });

// 2. Listing & Interactions (Tim/Comment)
Listing.hasMany(Comment, { foreignKey: 'listing_id', as: 'comments' });
Comment.belongsTo(Listing, { foreignKey: 'listing_id', as: 'listing' });

Listing.hasMany(Favorite, { foreignKey: 'listing_id', as: 'likes' });
Favorite.belongsTo(Listing, { foreignKey: 'listing_id', as: 'listing' });

// 3. User & Listing (Chủ nhà)
User.hasMany(Listing, { foreignKey: 'landlord_id' });
Listing.belongsTo(User, { foreignKey: 'landlord_id', as: 'landlord' }); // Khớp với scope 'withLandlord' của bạn

// 4. User & Interactions (Người đi comment/tim)
User.hasMany(Comment, { foreignKey: 'user_id', as: 'user_comments' });
Comment.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

User.hasMany(Favorite, { foreignKey: 'user_id', as: 'user_favorites' });
Favorite.belongsTo(User, { foreignKey: 'user_id', as: 'user' });

module.exports = { sequelize, User, Listing, ListingVideo, ListingImage, Comment, Favorite };