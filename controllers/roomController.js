// controllers/roomController.js
const { Listing, ListingImage } = require('../models');
const { Op } = require('sequelize'); // <<< ĐÃ BỔ SUNG

// @desc    Lấy danh sách phòng cho màn hình Home (explore + featured)
// @route   GET /api/v1/rooms/home
// @access  Public
const getHomeRooms = async (req, res) => {
  try {
    // Sử dụng scope 'active' để chỉ lấy phòng đang hoạt động
    const listings = await Listing.scope('active', 'withImages').findAll({
      attributes: [
        'listing_id', 
        'title', 
        'description', 
        'price', 
        'area', 
        'address', 
        'ward', 
        'district', 
        'city', 
        'latitude', 
        'longitude', 
        'status',
        'created_date'
      ],
      include: [{
        model: ListingImage,
        as: 'images',
        attributes: ['image_url', 'order_index'],
        required: false
      }],
      order: [['created_date', 'DESC']],
      limit: 20 
    });

    // Format dữ liệu cho Flutter
    const formattedListings = listings.map(listing => {
      const listingData = listing.get({ plain: true });
      
      return {
        listing_id: listingData.listing_id,
        title: listingData.title,
        address: listingData.address,
        price: parseFloat(listingData.price),
        area: parseFloat(listingData.area),
        image_url: listingData.images && listingData.images.length > 0 
          ? listingData.images[0].image_url 
          : 'https://via.placeholder.com/300x200?text=No+Image'
      };
    });

    // Phân chia thành explore (3 cái đầu) và featured (các cái còn lại)
    const exploreRooms = formattedListings.slice(0, 3);
    const featuredRooms = formattedListings.slice(3);

    res.status(200).json({
      status: 'success',
      data: {
        explore_rooms: exploreRooms,
        featured_rooms: featuredRooms,
        total: formattedListings.length
      }
    });

  } catch (error) {
    console.error('Error fetching home rooms:', error);
    res.status(500).json({
      status: 'error',
      message: 'Lỗi server khi lấy danh sách phòng cho home'
    });
  }
};

// @desc    Lấy tất cả phòng trọ (có hỗ trợ phân trang và lọc)
// @route   GET /api/v1/rooms
// @access  Public
const getAllRooms = async (req, res) => {
  try {
    const { page = 1, limit = 10, city, district, minPrice, maxPrice } = req.query;
    const offset = (parseInt(page) - 1) * parseInt(limit);

    let whereCondition = { status: 'active' };
    
    // Filter theo thành phố
    if (city) {
      whereCondition.city = city;
    }
    
    // Filter theo quận
    if (district) {
      whereCondition.district = district;
    }
    
    // Filter theo giá
    if (minPrice || maxPrice) {
      whereCondition.price = {};
      if (minPrice) whereCondition.price[Op.gte] = minPrice;
      if (maxPrice) whereCondition.price[Op.lte] = maxPrice;
    }

    const { count, rows: listings } = await Listing.findAndCountAll({
      where: whereCondition,
      attributes: [
        'listing_id', 
        'title', 
        'description', 
        'price', 
        'area', 
        'address', 
        'ward', 
        'district', 
        'city', 
        'status',
        'created_date'
      ],
      include: [{
        model: ListingImage,
        as: 'images',
        attributes: ['image_url', 'order_index'],
        required: false
      }],
      order: [['created_date', 'DESC']],
      limit: parseInt(limit),
      offset: offset
    });

    const formattedListings = listings.map(listing => {
      const listingData = listing.get({ plain: true });
      
      return {
        listing_id: listingData.listing_id,
        title: listingData.title,
        description: listingData.description,
        price: parseFloat(listingData.price),
        area: parseFloat(listingData.area),
        address: listingData.address,
        ward: listingData.ward,
        district: listingData.district,
        city: listingData.city,
        status: listingData.status,
        image_url: listingData.images && listingData.images.length > 0 
          ? listingData.images[0].image_url 
          : 'https://via.placeholder.com/300x200?text=No+Image'
      };
    });

    res.status(200).json({
      status: 'success',
      data: formattedListings,
      pagination: {
        current_page: parseInt(page),
        total_pages: Math.ceil(count / limit),
        total_items: count,
        items_per_page: parseInt(limit)
      }
    });

  } catch (error) {
    console.error('Error fetching rooms:', error);
    res.status(500).json({
      status: 'error',
      message: 'Lỗi server khi lấy danh sách phòng trọ'
    });
  }
};

// @desc    Lấy chi tiết phòng trọ
// @route   GET /api/v1/rooms/:id
// @access  Public
const getRoomById = async (req, res) => {
  try {
    const { id } = req.params;

    const listing = await Listing.scope('withImages').findOne({
      where: { listing_id: id },
      include: [{
        model: ListingImage,
        as: 'images',
        attributes: ['image_url', 'order_index'],
        required: false,
        order: [['order_index', 'ASC']]
      }]
    });

    if (!listing) {
      return res.status(404).json({
        status: 'error',
        message: 'Không tìm thấy phòng trọ'
      });
    }

    const listingData = listing.get({ plain: true });
    
    const formattedListing = {
      listing_id: listingData.listing_id,
      title: listingData.title,
      description: listingData.description,
      price: parseFloat(listingData.price),
      area: parseFloat(listingData.area),
      address: listingData.address,
      ward: listingData.ward,
      district: listingData.district,
      city: listingData.city,
      latitude: listingData.latitude ? parseFloat(listingData.latitude) : null,
      longitude: listingData.longitude ? parseFloat(listingData.longitude) : null,
      status: listingData.status,
      images: listingData.images || [],
      created_date: listingData.created_date
    };

    res.status(200).json({
      status: 'success',
      data: formattedListing
    });

  } catch (error) {
    console.error('Error fetching room details:', error);
    res.status(500).json({
      status: 'error',
      message: 'Lỗi server khi lấy thông tin phòng trọ'
    });
  }
};

module.exports = {
  getHomeRooms,
  getAllRooms,
  getRoomById
};