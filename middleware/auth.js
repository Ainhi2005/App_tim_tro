const { protect, restrictTo } = require('../utils/jwt');

// Alias middleware for better readability
const auth = protect;
const admin = restrictTo('admin');
const landlord = restrictTo('landlord');
const tenant = restrictTo('tenant');
const landlordOrAdmin = restrictTo('landlord', 'admin');

module.exports = {
  auth,
  admin,
  landlord,
  tenant,
  landlordOrAdmin
};