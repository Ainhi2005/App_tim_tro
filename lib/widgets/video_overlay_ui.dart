import 'package:flutter/material.dart';
import '../data/models/video_review_item.dart';


class VideoOverlayUI extends StatelessWidget {
  final VideoReviewItem item;
  final VoidCallback onLike;    // Callback khi bấm Like
  final VoidCallback onComment; // Callback khi bấm Comment

  const VideoOverlayUI({
    Key? key,
    required this.item,
    required this.onLike,       // Yêu cầu truyền vào
    required this.onComment,    // Yêu cầu truyền vào
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      // Căn lề an toàn cho các khu vực (tai thỏ, v.v.)
      padding: const EdgeInsets.all(16.0).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 100, // Né bottom bar
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Cột bên trái: Thông tin text
              Expanded(
                child: _buildInfoPanel(),
              ),
              // Cột bên phải: Các nút social
              Padding(
                padding: const EdgeInsets.only(bottom: 65.0),
                child: _buildSocialPanel(),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Cột thông tin (Title, Subtitle, Nút Xem)
  Widget _buildInfoPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(blurRadius: 2.0)],
          ),
        ),
        SizedBox(height: 8),
        Text(
          '${item.authorName} • ${item.location}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 15,
            shadows: [Shadow(blurRadius: 1.0)],
          ),
        ),
      ],
    );
  }

  // Cột tương tác (Avatar, Like, Comment, Share)
  Widget _buildSocialPanel() {
    return Column(
      children: [
        CircleAvatar(radius: 24, backgroundImage: NetworkImage(item.authorAvatarUrl)),
        SizedBox(height: 20),

        // NÚT LIKE
        _buildSocialButton(
          icon: item.isLiked ? Icons.favorite : Icons.favorite_border, // Đổi icon
          color: item.isLiked ? Colors.redAccent : Colors.white,       // Đổi màu
          text: item.likeCount.toString(),
          onTap: onLike, // Gọi callback
        ),
        SizedBox(height: 15),

        // NÚT COMMENT
        _buildSocialButton(
          icon: Icons.comment,
          text: item.commentCount.toString(),
          onTap: onComment, // Gọi callback
        ),
        SizedBox(height: 15),

        _buildSocialButton(icon: Icons.share, text: item.shareCount.toString(), onTap: () {}),
        SizedBox(height: 15),
        _buildSocialButton(icon: Icons.watch_later_outlined, text: '', onTap: () {}),
      ],
    );
  }

  // Widget con cho 1 nút social
  Widget _buildSocialButton({
    required IconData icon,
    required String text,
    Color color = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector( // Dùng GestureDetector hoặc InkWell
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32, shadows: [Shadow(blurRadius: 2, color: Colors.black26)]),
          if (text.isNotEmpty) ...[
            SizedBox(height: 4),
            Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14, shadows: [Shadow(blurRadius: 2, color: Colors.black26)])),
          ]
        ],
      ),
    );
  }
}