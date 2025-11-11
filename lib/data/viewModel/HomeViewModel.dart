import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../../screens/home/home_tab.dart';
import '../../screens/video/video_page.dart';
import '../../screens/map/map_page.dart';
import '../../screens/chat/chat_page.dart';
import '../../screens/account/account_page.dart';

class HomeViewModel extends ChangeNotifier {
  // -------------------
  // Slider, danh mục, phòng
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

  final List<RoomModel> exploreRooms = [
    RoomModel(name: 'Phòng cao cấp Q.1', address: '2W Street, NY, New York', price: 3000000, imageUrl: 'assets/images/room1.jpg'),
    RoomModel(name: 'Căn hộ Mini Q.Tân Bình', address: '4W Street, NY, New York', price: 20000000, imageUrl: 'assets/images/room2.jpg'),
    RoomModel(name: 'Nhà nguyên căn Bình Thạnh', address: '5W Street, NY, New York', price: 3450000, imageUrl: 'assets/images/room3.jpg'),
  ];

  final List<RoomModel> featuredRooms = [
    RoomModel(name: 'Phòng trọ mới xây', address: '28/3 Nguyễn Xí, Bình Thạnh', price: 3800000, imageUrl: 'assets/images/room1.jpg'),
    RoomModel(name: 'Chung cư mini cao cấp', address: 'Hẻm 458/16 Lê Văn Lương, Q.7', price: 5500000, imageUrl: 'assets/images/room2.jpg'),
    RoomModel(name: 'Nhà nguyên căn 2PN', address: '123/A/4 Trường Chinh, Tân Bình', price: 8000000, imageUrl: 'assets/images/room3.jpg'),
    RoomModel(name: 'Dormstay hiện đại', address: '10/B/9 Phạm Văn Đồng, Thủ Đức', price: 1500000, imageUrl: 'assets/images/room1.jpg'),
  ];

  // -------------------
  // Tab Index (dynamic)
  // -------------------
  int selectedIndex = 0;

  final List<Widget> pages = [
    const HomeTab(),
    const VideoPage(),
    const MapPage(),
    const ChatPage(),
    const AccountPage(),
  ];

  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners(); // 🔹 thông báo UI rebuild
  }
}
