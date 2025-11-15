// lib/data/viewModel/HomeViewModel.dart

import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../repositories/home_repositor.dart';
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
      final List<RoomModel> rooms = await _repo.getRooms();

      if (rooms.length >= 3) {
        exploreRooms = rooms.sublist(0, 3);
        featuredRooms = rooms.sublist(3);
      } else {
        exploreRooms = rooms;
        featuredRooms = [];
      }

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
