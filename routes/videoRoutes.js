// routes/videoRoutes.js
const express = require('express');
const videoController = require('../controllers/videoController');

const router = express.Router();

// SỬA: Đổi getVideoReviews thành getVideoFeed cho khớp với Controller
router.get('/', videoController.getVideoFeed); 

module.exports = router;