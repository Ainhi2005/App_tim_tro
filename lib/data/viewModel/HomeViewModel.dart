// lib/data/viewModel/HomeViewModel.dart

import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../repositories/home_repository.dart';
import '../service/api_service.dart';
import 'package:dio/dio.dart';

// Screens
import '../../screens/home/home_tab.dart';
import '../../screens/video/video_page.dart';
import '../../screens/map/map_page.dart';
import '../../screens/chat/chat_page.dart';
import '../../screens/account/account_page.dart';

enum ViewState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  // -------------------
  // Repository
  // -------------------
  late final HomeRepository _repo;

  HomeViewModel() {
    _repo = HomeRepository(ApiService(Dio()));
    fetchRooms();
  }

  // -------------------
  // Dữ liệu UI tĩnh
  // -------------------
  final List<String> images = [
    'assets/images/slide1.jpg',
    'assets/images/slide2.jpg',
    'assets/images/slide3.jpg',
  ];

  final List<Map<String, String>> categories = [
    {"title": "Trọ rẻ", "icon": "assets/icons/trore.png"},
    {"title": "Chung cư mini", "icon": "assets/icons/chungcumini.png"},
    {"title": "Nhà nguyên căn", "icon": "assets/icons/nhanguyencan.png"},
    {"title": "Dormstay", "icon": "assets/icons/dormstay.png"},
  ];

  // -------------------
  // Dữ liệu động từ API
  // -------------------
  List<RoomModel> exploreRooms = [];
  List<RoomModel> featuredRooms = [];

  ViewState _state = ViewState.idle;
  String errorMessage = "";

  ViewState get state => _state;

  // -------------------
  // Tải dữ liệu phòng từ Repository
  // -------------------
  Future<void> fetchRooms() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      // 1. Gọi hàm Repository mới
      final Map<String, List<RoomModel>> data = await _repo.getHomeRooms();

      // 2. Phân tách dữ liệu
      exploreRooms = data['explore'] ?? [];
      featuredRooms = data['featured'] ?? [];

      // Xóa logic sublist cũ vì backend đã phân chia

      _state = ViewState.success;
      notifyListeners();
    } catch (e) {
      _state = ViewState.error;
      errorMessage = "Lỗi khi tải phòng: $e";
      print(errorMessage);
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await fetchRooms();
  }

  // -------------------
  // Logic xử lý Tab
  // -------------------
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeTab(),
    const VideoPage(),
    const MapPage(),
    const ChatPage(),
    const AccountPage()
  ];

  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}