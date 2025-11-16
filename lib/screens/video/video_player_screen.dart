import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/video_review_item.dart';
import '../../data/viewModel/video_player_viewmodel.dart';
import 'package:video_player/video_player.dart';
import '../../widgets/video_overlay_ui.dart';

class VideoPlayerScreen extends StatelessWidget {
  final List<VideoReviewItem> reviews;
  final int initialIndex;

  const VideoPlayerScreen({
    Key? key,
    required this.reviews,
    required this.initialIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoPlayerViewModel(
        reviews: reviews,
        initialIndex: initialIndex,
      ),
      child: Consumer<VideoPlayerViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Phần video player
                PageView.builder(
                  controller: viewModel.pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: viewModel.reviews.length,
                  onPageChanged: viewModel.onPageChanged,
                  itemBuilder: (context, index) {
                    // Truyền index hiện tại để xây dựng video đúng
                    return _buildVideoPlayer(context, viewModel, index);
                  },
                ),

                // Phần UI overlay
                Consumer<VideoPlayerViewModel>(
                  builder: (context, viewModel, child) {
                    return VideoOverlayUI(
                      item: viewModel.reviews[viewModel.currentIndex],
                    );
                  },
                ),

                // Nút Back
                Positioned(
                  top: 50,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVideoPlayer(BuildContext context, VideoPlayerViewModel viewModel, int pageIndex) {
    // Chỉ hiển thị video nếu đây là trang hiện tại
    if (pageIndex != viewModel.currentIndex) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (viewModel.isLoading || viewModel.videoController == null) {
      return Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    return GestureDetector(
      onTap: () {
        // Nhấn vào màn hình để play/pause
        viewModel.togglePlayPause(); // Sửa tên hàm cho đúng
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: viewModel.videoController!.value.aspectRatio,
          child: VideoPlayer(viewModel.videoController!),
        ),
      ),
    );
  }
}