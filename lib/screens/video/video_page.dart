// lib/views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/viewModel/video_vm.dart';
import '../../widgets/video_card.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({Key? key}) : super(key: key);

  // Màu sắc chính từ ảnh
  final Color primaryColor = const Color(0xFF5A67D8);
  final Color screenBgColor = const Color(0xFFF4F4F9);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => video_vm(),
      child: Scaffold(
        backgroundColor: screenBgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _buildVideoList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho thanh Search và Filter
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  hintText: 'Tìm Kiếm',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          // Filter Button
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.filter_list, size: 20),
            label: Text('Lọc'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          )
        ],
      ),
    );
  }

  // Widget cho danh sách video
  Widget _buildVideoList() {
    // Dùng Consumer để lắng nghe vieo_vm
    return Consumer<video_vm>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: viewModel.reviews.length,
          itemBuilder: (context, index) {
            final review = viewModel.reviews[index];
            // Tách card ra 1 widget riêng
            return VideoReviewCard(review: review);
          },
        );
      },
    );
  }
}