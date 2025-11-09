import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

/// ===============================
/// MODEL: Định nghĩa kiểu dữ liệu cho 1 phòng
/// ===============================
class RoomModel {
  final String name;
  final String address;
  final double price;
  final String imageUrl;

  RoomModel({
    required this.name,
    required this.address,
    required this.price,
    required this.imageUrl,
  });
}

/// ===============================
/// HOME TAB (Màn hình chính)
/// ===============================
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Biến theo dõi index của slider ảnh
  int _currentIndex = 0;

  /// -------------------------------
  /// DỮ LIỆU MẪU
  /// -------------------------------

  // Danh sách ảnh cho Slider
  final List<String> _images = [
    'assets/images/slide1.jpg',
    'assets/images/slide2.jpg',
    'assets/images/slide3.jpg',
  ];

  // Danh mục loại phòng
  final List<Map<String, String>> _categories = [
    {"title": "Trọ rẻ", "icon": "assets/icons/trore.png"},
    {"title": "Chung cư mini", "icon": "assets/icons/chungcumini.png"},
    {"title": "Nhà nguyên căn", "icon": "assets/icons/nhanguyencan.png"},
    {"title": "Dormstay", "icon": "assets/icons/dormstay.png"},
  ];

  // Danh sách phòng “Khám phá” (hiển thị ngang)
  final List<RoomModel> _exploreRooms = [
    RoomModel(
      name: 'Phòng cao cấp Q.1',
      address: '2W Street, NY, New York',
      price: 3000000,
      imageUrl: 'assets/images/room1.jpg',
    ),
    RoomModel(
      name: 'Căn hộ Mini Q.Tân Bình',
      address: '4W Street, NY, New York',
      price: 20000000,
      imageUrl: 'assets/images/room2.jpg',
    ),
    RoomModel(
      name: 'Nhà nguyên căn Bình Thạnh',
      address: '5W Street, NY, New York',
      price: 3450000,
      imageUrl: 'assets/images/room3.jpg',
    ),
  ];

  // Danh sách phòng “Trọ rẻ nổi bật” (hiển thị dọc)
  final List<RoomModel> _featuredRooms = [
    RoomModel(
      name: 'Phòng trọ mới xây',
      address: '28/3 Nguyễn Xí, Bình Thạnh',
      price: 3800000,
      imageUrl: 'assets/images/room1.jpg',
    ),
    RoomModel(
      name: 'Chung cư mini cao cấp',
      address: 'Hẻm 458/16 Lê Văn Lương, Q.7',
      price: 5500000,
      imageUrl: 'assets/images/room2.jpg',
    ),
    RoomModel(
      name: 'Nhà nguyên căn 2PN',
      address: '123/A/4 Trường Chinh, Tân Bình',
      price: 8000000,
      imageUrl: 'assets/images/room3.jpg',
    ),
    RoomModel(
      name: 'Dormstay hiện đại',
      address: '10/B/9 Phạm Văn Đồng, Thủ Đức',
      price: 1500000,
      imageUrl: 'assets/images/room1.jpg',
    ),
  ];

  /// ===============================
  /// HÀM DỰNG GIAO DIỆN TỪNG PHẦN
  /// ===============================

  /// --- 1. ROOM CARD NGANG (cho phần “Khám phá”) ---
  Widget _buildExploreRoomCard(RoomModel room) {
    String formatExplorePrice(double price) => '\$${price.toStringAsFixed(0)},000';

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh phòng
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(room.imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          // Nội dung
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  formatExplorePrice(room.price),
                  style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                // Thông tin chi tiết (diện tích, phòng, WC)
                const Row(
                  children: [
                    Icon(Icons.square_foot, size: 14, color: Colors.redAccent),
                    Text(' 200m²', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 8),
                    Icon(Icons.bed, size: 14, color: Colors.redAccent),
                    Text(' 1', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 8),
                    Icon(Icons.bathtub, size: 14, color: Colors.redAccent),
                    Text(' 1', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// --- 2. ROOM CARD DỌC (cho phần “Trọ rẻ nổi bật”) ---
  Widget _buildFeaturedRoomCard(RoomModel room) {
    // Định dạng giá tiền kiểu VNĐ, ví dụ: 3.800K VNĐ
    String formatPrice(double price) {
      final int amountInK = (price / 1000).round();
      return '${amountInK.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]}.',
      )}K VNĐ';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh phòng
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(room.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),

          // Thông tin chi tiết
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tên và Giá
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(room.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(formatPrice(room.price),
                        style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 4),

                // Địa chỉ
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        room.address,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Chi tiết phòng
                const Row(
                  children: [
                    Icon(Icons.square_foot, size: 14, color: Colors.redAccent),
                    Text(' 25m²', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 12),
                    Icon(Icons.bed, size: 14, color: Colors.redAccent),
                    Text(' 1PN', style: TextStyle(fontSize: 12)),
                    SizedBox(width: 12),
                    Icon(Icons.bathtub_outlined, size: 14, color: Colors.redAccent),
                    Text(' 1WC', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// GIAO DIỆN CHÍNH
  /// ===============================
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// --- 1. PHẦN SLIDER ẢNH ---
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider(
                items: _images.map((img) {
                  return Image.asset(img, fit: BoxFit.cover, width: double.infinity);
                }).toList(),
                options: CarouselOptions(
                  height: 200,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  onPageChanged: (index, reason) => setState(() => _currentIndex = index),
                ),
              ),
              // Dấu chấm trượt
              Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _images.asMap().entries.map((entry) {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == entry.key ? Colors.white : Colors.white54,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          /// --- 2. PHẦN THANH TÌM KIẾM + DANH MỤC ---
          Container(
            width: double.infinity,
            color: const Color(0xFF1E40AF),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thanh tìm kiếm
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(hintText: 'Tìm kiếm', border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Nút lọc
                    Container(
                      decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(8),
                      child: const Row(
                        children: [
                          Icon(Icons.filter_alt, color: Colors.blue),
                          SizedBox(width: 4),
                          Text('Lọc'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Danh mục
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _categories.map((cat) {
                    return Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration:
                          const BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
                          child: Center(
                            child: Image.asset(cat['icon']!, width: 45, height: 45),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(cat['title']!, style: const TextStyle(color: Colors.white)),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          /// --- 3. PHẦN "KHÁM PHÁ" ---
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề + nút đăng tin
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Khám phá', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text('Đăng tin tìm phòng', style: TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF1E40AF),
                        elevation: 3,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: const BorderSide(color: Color(0xFF1E40AF)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Danh sách phòng khám phá
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: _exploreRooms.map(_buildExploreRoomCard).toList()),
                ),

                const SizedBox(height: 16),

                // Nút xem tất cả
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Xem tất cả'),
                  ),
                ),

                const SizedBox(height: 24),

                /// --- 4. PHẦN “TRỌ RẺ NỔI BẬT” ---
                const Text('Trọ rẻ nổi bật',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                // Danh sách phòng nổi bật
                Column(children: _featuredRooms.map(_buildFeaturedRoomCard).toList()),

                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E40AF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Xem tất cả'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
