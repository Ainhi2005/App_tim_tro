import 'package:dio/dio.dart';
import '../models/video_review_item.dart';
import '../models/comment_model.dart';
import '../service/api_service.dart';

class VideoRepository {
  late final ApiService _apiService;

  // Constructor: Nên cho phép truyền ApiService vào (Dependency Injection)
  // để sau này dễ test hoặc dùng chung 1 instance của Dio.
  VideoRepository({ApiService? apiService}) {
    if (apiService != null) {
      _apiService = apiService;
    } else {
      // Fallback: Tạo mới nếu không được truyền vào (giống code cũ của bạn)
      final dio = Dio();
      dio.interceptors.add(LogInterceptor(responseBody: true));
      _apiService = ApiService(dio);
    }
  }

  Future<List<VideoReviewItem>> fetchVideoReviews() async {
    try {
      final response = await _apiService.getVideoFeed();
      // Nếu Backend trả về null thì trả về list rỗng để tránh crash app
      return response.data;
    } catch (e) {
      // Bạn có thể xử lý lỗi custom ở đây nếu muốn
      rethrow;
    }
  }
  Future<void> toggleLike(String listingId) async {
    await _apiService.toggleFavorite({'listing_id': listingId});
  }

  // Hàm lấy bình luận (Parse từ JSON trả về list CommentModel)
  // ... code cũ ...

  // Hàm lấy bình luận
  Future<List<CommentModel>> getComments(String listingId) async {
    // 1. Lấy dữ liệu thô (dynamic)
    final response = await _apiService.getComments(listingId);

    // 2. Ép kiểu thủ công sang Map
    final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(response);

    // 3. Lấy list data bên trong
    final List<dynamic> dataList = jsonMap['data'] ?? [];

    // 4. Map sang Model
    return dataList.map((json) => CommentModel.fromJson(json)).toList();
  }

  // Hàm gửi bình luận
  Future<CommentModel> sendComment(String listingId, String content) async {
    final response = await _apiService.addComment({
      'listing_id': listingId,
      'content': content
    });

    // Ép kiểu thủ công và parse
    final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(response);
    return CommentModel.fromJson(jsonMap['data']);
  }
}