import 'package:flutter/material.dart';
import '../../../data/models/room_model.dart';
import '../../../theme/text_styles.dart';
import '../../../theme/colors.dart';

class RoomCard extends StatelessWidget {
  final RoomModel room;
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(room.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
        ),
        title: Text(room.name, style: AppTextStyles.title),
        subtitle: Text(room.address, style: AppTextStyles.subtitle),
        trailing: Text(
          '\$${room.price}',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
        ),
      ),
    );
  }
}
