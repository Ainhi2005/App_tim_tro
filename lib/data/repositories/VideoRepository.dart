import 'package:dio/dio.dart';
import '../models/video_review_item.dart';
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
}