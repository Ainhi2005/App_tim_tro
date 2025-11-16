//lib/data/viewModel/video_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/video_review_item.dart';
import '../service/video_service.dart'; // <-- Gọi Service

// 1. Đổi tên class cho chuẩn Dart
class VideoViewModel extends ChangeNotifier {

  // 2. Tiêm (inject) service vào
  final VideoService _videoService = VideoService();

  List<VideoReviewItem> _reviews = [];
  bool _isLoading = false;

  // 3. Thêm biến xử lý lỗi
  String? _errorMessage;

  List<VideoReviewItem> get reviews => _reviews;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  VideoViewModel() {
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    _isLoading = true;
    _errorMessage = null; // Xóa lỗi cũ
    notifyListeners();

    try {
      // 4. Ủy quyền việc fetch cho Service
      _reviews = await _videoService.fetchVideoReviews();

    } catch (e) {
      // 5. Bắt lỗi nếu service thất bại
      _errorMessage = e.toString();

    } finally {
      // 6. Luôn tắt loading dù thành công hay thất bại
      _isLoading = false;
      notifyListeners();
    }
  }
}