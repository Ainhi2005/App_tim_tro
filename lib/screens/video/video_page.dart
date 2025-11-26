import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/viewModel/video_viewmodel.dart';
import '../../widgets/video_card.dart';
import 'video_player_screen.dart'; // <-- 1. IMPORT MỚI

class VideoPage extends StatelessWidget {
  const VideoPage({Key? key}) : super(key: key);

  final Color primaryColor = const Color(0xFF5A67D8);
  final Color screenBgColor = const Color(0xFFF4F4F9);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoViewModel(),
      child: Scaffold(
        backgroundColor: screenBgColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Consumer<VideoViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (viewModel.errorMessage != null) {
                      return Center(child: Text(viewModel.errorMessage!));
                    }

                    // Gọi hàm _buildVideoList với viewModel đã sẵn sàng
                    return _buildVideoList(context, viewModel);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget cho thanh Search và Filter (Giữ nguyên)
  Widget _buildHeader(BuildContext context) {
    // ... (Không thay đổi)
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 12.0),
      child: Row(
        children: [
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
  Widget _buildVideoList(BuildContext context, VideoViewModel viewModel) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: viewModel.reviews.length,
      itemBuilder: (context, index) {
        final review = viewModel.reviews[index];
        return VideoReviewCard(
          review: review,
          // --- 2. THÊM LOGIC `onTap` ---
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value( // Dùng .value để tái sử dụng ViewModel cũ
                  value: viewModel,
                  child: VideoPlayerScreen(
                    reviews: viewModel.reviews,
                    initialIndex: index,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}