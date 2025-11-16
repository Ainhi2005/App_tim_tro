// lib/viewmodels/home_viewmodel.dart
import 'package:flutter/material.dart';
import '../models/VideoReview.dart';

class video_vm extends ChangeNotifier {
  List<VideoReview> _reviews = [];
  bool _isLoading = false;

  // View chỉ có thể "get" dữ liệu, không thể "set" trực tiếp
  List<VideoReview> get reviews => _reviews;
  bool get isLoading => _isLoading;

  video_vm() {
    // Tải dữ liệu giả lập khi ViewModel được khởi tạo
    fetchReviews();
  }

  // Logic nghiệp vụ (ví dụ: gọi API)
  Future<void> fetchReviews() async {
    _isLoading = true;
    notifyListeners(); // Báo cho View biết là đang loading

    // Giả lập độ trễ mạng
    await Future.delayed(Duration(seconds: 1));

    // Tạo dữ liệu giả (mock data) giống hệt trong ảnh
    _reviews = [
      VideoReview(
        id: '1',
        title: 'Review khu trọ gần ĐH Bách Khoa',
        authorName: 'Ái Nhi',
        location: 'Khu vực Hai Bà Trưng',
        // Lấy URL ảnh avatar từ ảnh mẫu của bạn
        authorAvatarUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763194573/883e5e3e-44c5-4015-853e-f6743d73f1e8.png',
        thumbnailUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763193948/meme-hai-29_epkzgk.jpg', // Chưa dùng đến
      ),
      VideoReview(
        id: '2',
        title: 'Review khu trọ gần ĐH Bách Khoa',
        authorName: 'Ái Nhi',
        location: 'Khu vực Hai Bà Trưng',
        authorAvatarUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763194573/883e5e3e-44c5-4015-853e-f6743d73f1e8.png',
        thumbnailUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763193948/meme-hai-29_epkzgk.jpg',
      ),
      VideoReview(
        id: '3',
        title: 'Review khu trọ gần ĐH Bách Khoa',
        authorName: 'Ái Nhi',
        location: 'Khu vực Hai Bà Trưng',
        authorAvatarUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763194573/883e5e3e-44c5-4015-853e-f6743d73f1e8.png',
        thumbnailUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763193948/meme-hai-29_epkzgk.jpg',
      ),
    ];

    _isLoading = false;
    notifyListeners(); // Báo cho View biết đã tải xong, hãy build lại
  }
}