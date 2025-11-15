// lib/data/repositories/home_repository.dart

import '../models/room_model.dart';
import '../service/api_service.dart';

class HomeRepository {
  final ApiService api;

  HomeRepository(this.api);

  Future<List<RoomModel>> getRooms() async {
    final data = await api.getRooms();
    return data;
  }
}
