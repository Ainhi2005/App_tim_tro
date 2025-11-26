import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/video_review_item.dart';
import '../models/comment_model.dart';
import '../service/api_service.dart';

class VideoRepository {
  late ApiService _apiService;

  VideoRepository() {
    final dio = Dio();

    // --- CẤU HÌNH TỰ ĐỘNG GỬI TOKEN (ĐÃ SỬA KHỚP VỚI LOGIN CŨ) ---
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();

          // SỬA Ở ĐÂY: Đổi 'USER_TOKEN' thành 'token' để khớp với AuthViewModel cũ của bạn
          final token = prefs.getString('token');

          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
            print("🔑 Gửi Request kèm Token: ${token.substring(0, 5)}...");
          } else {
            print("⚠️ Cảnh báo: KHÔNG CÓ TOKEN (Chưa đăng nhập?)");
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          print("❌ Lỗi API: ${e.response?.statusCode} - ${e.response?.data}");
          return handler.next(e);
        }
    ));
    // -----------------------------------------------------------

    _apiService = ApiService(dio);
  }

  // --- CÁC HÀM GỌI API (GIỮ NGUYÊN) ---

  Future<List<VideoReviewItem>> fetchVideoReviews() async {
    final response = await _apiService.getVideoFeed();
    return response.data;
  }

  Future<void> toggleLike(String listingId) async {
    await _apiService.toggleFavorite({'listing_id': listingId});
  }

  Future<List<CommentModel>> getComments(String listingId) async {
    final response = await _apiService.getComments(listingId);
    final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(response as Map);
    final List<dynamic> dataList = jsonMap['data'] ?? [];
    return dataList.map((json) => CommentModel.fromJson(json)).toList();
  }

  Future<CommentModel> sendComment(String listingId, String content) async {
    final response = await _apiService.addComment({
      'listing_id': listingId,
      'content': content
    });
    final Map<String, dynamic> jsonMap = Map<String, dynamic>.from(response as Map);
    return CommentModel.fromJson(jsonMap['data']);
  }
}
