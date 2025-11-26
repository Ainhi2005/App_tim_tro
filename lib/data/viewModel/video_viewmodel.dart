import 'package:flutter/material.dart';
import '../models/video_review_item.dart';
import '../repositories/VideoRepository.dart';
import '../models/comment_model.dart'; // Import model comment

class VideoViewModel extends ChangeNotifier {
  final VideoRepository _videoRepository = VideoRepository();

  List<VideoReviewItem> _reviews = [];
  bool _isLoading = false;
  String? _errorMessage;

  // State cho comment
  List<CommentModel> _currentComments = [];
  bool _isCommentsLoading = false;

  List<VideoReviewItem> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CommentModel> get currentComments => _currentComments;
  bool get isCommentsLoading => _isCommentsLoading;

  VideoViewModel() {
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _reviews = await _videoRepository.fetchVideoReviews();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- LOGIC LIKE ---
  Future<void> toggleLike(int index) async {
    final item = _reviews[index];

    // Optimistic Update: Cập nhật UI ngay lập tức
    final isLikedNew = !item.isLiked;
    final likeCountNew = isLikedNew ? item.likeCount + 1 : item.likeCount - 1;

    // Tạo bản sao mới của item với trạng thái đã đổi (vì model final)
    final newItem = VideoReviewItem(
      id: item.id,
      listingId: item.listingId,
      title: item.title,
      authorName: item.authorName,
      location: item.location,
      authorAvatarUrl: item.authorAvatarUrl,
      thumbnailUrl: item.thumbnailUrl,
      videoUrl: item.videoUrl,
      likeCount: likeCountNew,
      commentCount: item.commentCount,
      shareCount: item.shareCount,
      isLiked: isLikedNew,
    );

    _reviews[index] = newItem;
    notifyListeners(); // Báo UI vẽ lại tim đỏ/trắng ngay

    // Gọi API cập nhật server
    try {
      await _videoRepository.toggleLike(item.listingId);
    } catch (e) {
      print("Lỗi like API: $e");
      // Nếu lỗi thì revert lại (tùy chọn)
    }
  }

  // --- LOGIC COMMENT ---
  Future<void> loadComments(String listingId) async {
    _isCommentsLoading = true;
    _currentComments = []; // Reset list
    notifyListeners();
    try {
      _currentComments = await _videoRepository.getComments(listingId);
    } catch (e) {
      print("Lỗi load comments: $e");
    } finally {
      _isCommentsLoading = false;
      notifyListeners();
    }
  }

  Future<void> postComment(String listingId, String content) async {
    if (content.trim().isEmpty) return;
    try {
      final newComment = await _videoRepository.sendComment(listingId, content);
      _currentComments.insert(0, newComment); // Hiện comment mới lên đầu
      notifyListeners();
    } catch (e) {
      print("Lỗi post comment: $e");
    }
  }
}