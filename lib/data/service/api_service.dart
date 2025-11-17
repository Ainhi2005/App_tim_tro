// api_service.dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/request/loginRequest.dart';
import '../models/request/register_request.dart';
import '../models/response/loginResponse.dart';
import '../models/response/register_response.dart';
import '../models/room_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://192.168.100.202:5000/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("api/v1/auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST("api/v1/auth/register")
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @GET("api/v1/rooms/")
  Future<List<RoomModel>> getRooms();
}