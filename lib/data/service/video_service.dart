//lib/data/viewModel/video_viewmodel.dart
import '../models/video_review_item.dart';

class VideoService {

  // Hàm này sẽ gọi API thật
  Future<List<VideoReviewItem>> fetchVideoReviews() async {
    // Giả lập độ trễ mạng
    await Future.delayed(Duration(seconds: 1));

    // Dữ liệu giả (mock data) giống hệt trong ảnh
    // (Đã cập nhật theo model mới)
    final reviews = [
      VideoReviewItem(
        id: '1',
        listingId: 'listing_1',
        title: 'Review khu trọ gần ĐH Bách Khoa',
        authorName: 'Ái Nhi',
        location: 'Khu vực Hai Bà Trưng',
        authorAvatarUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763194573/883e5e3e-44c5-4015-853e-f6743d73f1e8.png',
        thumbnailUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763193948/meme-hai-29_epkzgk.jpg',
        videoUrl:'https://res.cloudinary.com/dcapucva9/video/upload/v1763192620/7226707595454_qjzawc.mp4',
        likeCount: 999,
        commentCount: 10,
        shareCount: 3,
      ),
      VideoReviewItem(
        id: '2',
        listingId: 'listing_2',
        title: 'Review khu trọ gần ĐH Bách Khoa',
        authorName: 'Ái Nhi',
        location: 'Khu vực Hai Bà Trưng',
        authorAvatarUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763194573/883e5e3e-44c5-4015-853e-f6743d73f1e8.png',
        thumbnailUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763193948/meme-hai-29_epkzgk.jpg',
        videoUrl:'https://res.cloudinary.com/dcapucva9/video/upload/v1763194277/r3_e3peyi.mp4',
        likeCount: 521,
        commentCount: 8,
        shareCount: 2,
      ),
      VideoReviewItem(
        id: '3',
        listingId: 'listing_3',
        title: 'Review khu trọ gần ĐH Bách Khoa',
        authorName: 'Ái Nhi',
        location: 'Khu vực Hai Bà Trưng',
        authorAvatarUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763194573/883e5e3e-44c5-4015-853e-f6743d73f1e8.png',
        thumbnailUrl: 'https://res.cloudinary.com/dcapucva9/image/upload/v1763193948/meme-hai-29_epkzgk.jpg',
        videoUrl: 'https://res.cloudinary.com/dcapucva9/video/upload/v1763194257/r2_oqd8ej.mp4',
        likeCount: 1080,
        commentCount: 22,
        shareCount: 7,
      ),
    ];

    // Giả lập lỗi (bạn có thể bỏ comment dòng dưới để test)
    // throw Exception("Không thể tải video");

    return reviews;
  }
}