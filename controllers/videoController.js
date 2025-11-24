const { Listing, ListingVideo, ListingImage, User, sequelize } = require('../models');

exports.getVideoFeed = async (req, res) => {
  try {
    const currentUserId = req.user ? req.user.user_id : null;
    const { page = 1, limit = 10 } = req.query;
    const offset = (page - 1) * limit;

    // Dùng Listing làm gốc để lấy tin
    const listings = await Listing.findAll({
      // Dùng scope 'active' của bạn để lọc tin rác/hết hạn
      // Dùng scope 'withLandlord' để lấy thông tin chủ nhà
      // Dùng scope 'withImages' để lấy ảnh
      limit: parseInt(limit),
      offset: parseInt(offset),
      order: [['created_date', 'DESC']], // Khớp với Listing.js của bạn
      where: {
        status: 'active' // Đảm bảo chỉ lấy tin active
      },
      include: [
        {
          model: ListingVideo,
          as: 'videos',
          required: true, // BẮT BUỘC PHẢI CÓ VIDEO mới hiện
          attributes: ['video_url', 'thumbnail_url', 'description']
        },
        {
          model: ListingImage,
          as: 'images',
          required: false,
          attributes: ['image_url', 'order_index']
        },
        {
          model: User,
          as: 'landlord',
          attributes: ['user_id', 'full_name', 'avatar_url', 'phone']
        }
      ],
      attributes: {
        include: [
          // Đếm TIM
          [sequelize.literal(`(SELECT COUNT(*)::int FROM favorites AS f WHERE f.listing_id = "Listing"."listing_id")`), 'like_count'],
          // Đếm COMMENT
          [sequelize.literal(`(SELECT COUNT(*)::int FROM comments AS c WHERE c.listing_id = "Listing"."listing_id" AND c.status = 'approved')`), 'comment_count'],
          // Check User đã TIM chưa
          [sequelize.literal(`(SELECT EXISTS (SELECT 1 FROM favorites AS f WHERE f.listing_id = "Listing"."listing_id" AND f.user_id = ${currentUserId || 0}))`), 'is_liked']
        ]
      }
    });

    res.status(200).json({
      status: 'success',
      data: listings
    });

  } catch (error) {
    console.error('Video Feed Error:', error);
    res.status(500).json({ status: 'error', message: error.message });
  }
};