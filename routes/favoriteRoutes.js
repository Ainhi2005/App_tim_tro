// routes/favoriteRoutes.js
const express = require('express');
const favoriteController = require('../controllers/favoriteController');
const { protect } = require('../utils/jwt'); 

const router = express.Router();

router.use(protect);

router.route('/')
  .get(favoriteController.getFavorites)     // Dòng này sẽ hết lỗi sau khi sửa controller
  .post(favoriteController.toggleFavorite);

module.exports = router;