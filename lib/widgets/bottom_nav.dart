import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Bottom bar với góc bo tròn
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35),   // ✅ Bo góc trên trái
              topRight: Radius.circular(35),  // ✅ Bo góc trên phải
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined,
                    label: 'Trang chủ',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: Icons.videocam_outlined,
                    label: 'Video',
                    index: 1,
                  ),
                  const SizedBox(width: 56), // ✅ Khoảng trống cho icon giữa
                  _buildNavItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Tin nhắn',
                    index: 3,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline,
                    label: 'Tài khoản',
                    index: 4,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Icon map nổi lên trên
        Positioned(
          bottom: 45, // ✅ Đẩy lên trên 30px
          child: _buildCenterNavItem(),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? AppColors.primaryBlue : Colors.grey[400],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.primaryBlue : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    // Kích thước của icon: Giữ nguyên 30x30px
    const double iconSize = 30;

    return GestureDetector(
      onTap: () => onTap(2),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.4), // Dùng withOpacity thay vì withValues
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ICON TỪ ASSETS ĐÃ ĐƯỢC CHÈN VÀO ĐÂY
            Image.asset(
              'assets/icons/icon_map.png', // <-- ĐƯỜNG DẪN MỚI CỦA BẠN
              width: 55,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}