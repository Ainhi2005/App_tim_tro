// lib/widgets/video_review_card.dart
import 'package:flutter/material.dart';
import '../data/models/video_review_item.dart';

class VideoReviewCard extends StatelessWidget {
  final VideoReviewItem review;
  final VoidCallback onTap;

  const VideoReviewCard({Key? key, required this.review, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap, // <-- SỬ DỤNG
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: Offset(0, 4),
          ),
        ],
      ),
      // ClipRRect để bo tròn cho widget con bên trong (cái thumbnail)
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần thumbnail màu xám
            _buildThumbnail(),
            // Phần thông tin (avatar, text)
            _buildInfo(),
          ],
        ),
      ),),
    );
  }

  // Widget cho thumbnail (màu xám + icon)
  Widget _buildThumbnail() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
            image: DecorationImage(
              // 2. Truyền NetworkImage vào `image` của DecorationImage
              image: NetworkImage(review.thumbnailUrl),
              fit: BoxFit.cover, )
          ), // Màu xám nhạt như trong ảnh
        ),
        Icon(
          Icons.videocam,
          color: Color(0xFF5A67D8), // Màu xanh của icon
          size: 50,
        ),
      ],
    );
  }

  // Widget cho thông tin (avatar, title, subtitle)
  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(review.authorAvatarUrl),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  '${review.authorName} • ${review.location}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
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