// lib/data/repositories/home_repository.dart

import '../models/room_model.dart';
import '../service/api_service.dart';

class HomeRepository {
  final ApiService api;

  HomeRepository(this.api);

  // Sửa hàm để trả về cả hai danh sách phòng
  Future<Map<String, List<RoomModel>>> getHomeRooms() async {
    final response = await api.getHomeRooms();

    // Trả về một Map chứa cả hai danh sách
    return {
      'explore': response.data.exploreRooms,
      'featured': response.data.featuredRooms,
    };
  }
}