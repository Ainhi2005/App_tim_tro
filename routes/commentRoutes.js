// routes/commentRoutes.js
const express = require('express');
const commentController = require('../controllers/commentController');
const { protect } = require('../utils/jwt'); // BẬT LẠI dòng này (nhớ trỏ đúng đường dẫn utils)

const router = express.Router();

// Ai cũng xem được comment
router.get('/', commentController.getComments);  

// SỬA: Thêm middleware protect vào đây. Phải đăng nhập mới được comment.
router.post('/', protect, commentController.addComment); 

module.exports = router;