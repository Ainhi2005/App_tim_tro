const { Comment, User } = require('../models');

// Lấy danh sách comment (API: GET /api/v1/comments?listingId=123)
exports.getComments = async (req, res) => {
  try {
    const { listingId } = req.query;
    if (!listingId) return res.status(400).json({ message: 'Thiếu listingId' });

    const comments = await Comment.findAll({
      where: { listing_id: listingId, status: 'approved' },
      order: [['timestamp', 'DESC']],
      include: [{
        model: User,
        as: 'user',
        attributes: ['user_id', 'full_name', 'avatar_url'] // Avatar người comment
      }]
    });

    res.status(200).json({ status: 'success', data: comments });
  } catch (error) {
    res.status(500).json({ status: 'error', message: error.message });
  }
};

// Chat comment mới (API: POST /api/v1/comments)
exports.addComment = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { listing_id, content, rating } = req.body;
    const newComment = await Comment.create({
      user_id: userId,
      listing_id,
      content,
      rating: rating || null,
      status: 'approved'
    });

    // Trả về comment kèm thông tin user để app hiện luôn
    const fullComment = await Comment.findByPk(newComment.comment_id, {
      include: [{ model: User, as: 'user', attributes: ['user_id', 'full_name', 'avatar_url'] }]
    });

    res.status(201).json({ status: 'success', data: fullComment });
  } catch (error) {
    res.status(500).json({ status: 'error', message: error.message });
  }
};