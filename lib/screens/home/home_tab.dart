import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../data/models/room_model.dart';
import '../../data/viewModel/HomeViewModel.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Gọi fetch data khi tab được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<HomeViewModel>();
      if (vm.state == ViewState.idle) {
        vm.fetchRooms();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Scaffold(
      body: _buildContent(vm),
    );
  }

  Widget _buildContent(HomeViewModel vm) {
    switch (vm.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi: ${vm.errorMessage}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => vm.fetchRooms(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        );
      case ViewState.success:
      case ViewState.idle:
        return _buildSuccessContent(vm);
    }
  }

  Widget _buildSuccessContent(HomeViewModel vm) {
    return RefreshIndicator(
      onRefresh: () => vm.refresh(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSlider(vm),
            _buildSearchBar(vm),
            const SizedBox(height: 10),
            _buildExploreSection(vm),
            const SizedBox(height: 16),
            _buildFeaturedSection(vm),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(HomeViewModel vm) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          items: vm.images
              .map(
                (img) => Image.asset(
              img,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 250,
            ),
          )
              .toList(),
          options: CarouselOptions(
            height: 250,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) => setState(() => _currentIndex = index),
          ),
        ),
        Positioned(
          bottom: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: vm.images.asMap().entries.map((entry) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentIndex == entry.key ? 12 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: _currentIndex == entry.key
                      ? Colors.white
                      : Colors.white.withAlpha((255 * 0.4).round()),
                ),
              );
            }).toList(),
          ),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              // TODO: Navigate to notifications page
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(HomeViewModel vm) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF1E40AF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm phòng trọ...',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.filter_alt, color: Color(0xFF1E40AF)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: vm.categories.map((cat) {
              return Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Image.asset(cat['icon']!, width: 40, height: 40)),
                  ),
                  const SizedBox(height: 6),
                  Text(cat['title']!, style: const TextStyle(color: Colors.white)),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreSection(HomeViewModel vm) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Khám phá', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to post room page
                },
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
          const SizedBox(height: 12),
          if (vm.exploreRooms.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Không có phòng nào để hiển thị'),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: vm.exploreRooms.map((r) => _buildExploreCard(r)).toList(),
              ),
            ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to all explore rooms
              },
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
    );
  }

  Widget _buildExploreCard(RoomModel room) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network( // Sửa Image.asset thành Image.network vì data từ API
              room.imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  _formatVnd(room.price),
                  style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.square_foot, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text('${room.area}m²', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(HomeViewModel vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trọ rẻ nổi bật', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (vm.featuredRooms.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('Không có phòng nổi bật nào'),
            )
          else
            Column(
              children: vm.featuredRooms.map((r) => _buildFeaturedCard(r)).toList(),
            ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to all featured rooms
              },
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
    );
  }

  Widget _buildFeaturedCard(RoomModel room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network( // Sửa Image.asset thành Image.network
              room.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.home, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        room.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      _formatVnd(room.price),
                      style: const TextStyle(color: Color(0xFF1E40AF), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
                Row(
                  children: [
                    const Icon(Icons.square_foot, size: 14, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Text('${room.area}m²', style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatVnd(double price) {
    final amountInK = (price / 1000).round();
    final formatted = amountInK.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
    );
    return '${formatted}K VNĐ';
  }
}