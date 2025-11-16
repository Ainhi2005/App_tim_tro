import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/room_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://192.168.1.6:3000")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/rooms")
  Future<List<RoomModel>> getRooms();
}