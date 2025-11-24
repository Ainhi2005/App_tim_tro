// controllers/favoriteController.js
const { Favorite } = require('../models');

// API: Thả tim / Bỏ tim
exports.toggleFavorite = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { listing_id } = req.body; // Nhận listing_id từ client

    if (!listing_id) {
      return res.status(400).json({ message: 'Thiếu listing_id' });
    }

    const whereCondition = { user_id: userId, listing_id };
    const existingFavorite = await Favorite.findOne({ where: whereCondition });

    if (existingFavorite) {
      await existingFavorite.destroy();
      return res.status(200).json({ 
        status: 'success', 
        action: 'unliked', 
        message: 'Đã bỏ thích' 
      });
    } else {
      await Favorite.create(whereCondition);
      return res.status(201).json({ 
        status: 'success', 
        action: 'liked', 
        message: 'Đã thích' 
      });
    }
  } catch (error) {
    console.error('Toggle Favorite Error:', error);
    res.status(500).json({ status: 'error', message: error.message });
  }
};

// API: Lấy danh sách yêu thích (Cần hàm này để không bị lỗi route)
exports.getFavorites = async (req, res) => {
  try {
    // Tạm thời trả về thông báo chưa có tính năng, hoặc list rỗng
    // Sau này bạn có thể code logic lấy list listing đã like ở đây
    res.status(200).json({
      status: 'success',
      message: 'Tính năng xem danh sách yêu thích đang phát triển',
      data: []
    });
  } catch (error) {
    res.status(500).json({ status: 'error', message: error.message });
  }
};