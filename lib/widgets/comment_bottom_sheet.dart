import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/viewModel/video_viewmodel.dart';

class CommentBottomSheet extends StatefulWidget {
  final String listingId;

  const CommentBottomSheet({Key? key, required this.listingId}) : super(key: key);

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load comment ngay khi mở sheet
    Future.microtask(() =>
        Provider.of<VideoViewModel>(context, listen: false)
            .loadComments(widget.listingId));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7, // Cao 70% màn hình
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 1. Tiêu đề
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const Text("Bình luận", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          const Divider(height: 1),

          // 2. Danh sách Comment
          Expanded(
            child: Consumer<VideoViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.isCommentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.currentComments.isEmpty) {
                  return const Center(child: Text("Chưa có bình luận nào."));
                }
                return ListView.builder(
                  itemCount: viewModel.currentComments.length,
                  itemBuilder: (context, index) {
                    final comment = viewModel.currentComments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: comment.userAvatar.isNotEmpty
                            ? NetworkImage(comment.userAvatar)
                            : null,
                        child: comment.userAvatar.isEmpty ? const Icon(Icons.person) : null,
                      ),
                      title: Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      subtitle: Text(comment.content),
                    );
                  },
                );
              },
            ),
          ),

          // 3. Ô nhập liệu
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 10, // Đẩy lên khi bàn phím hiện
                left: 10, right: 10, top: 10
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Thêm bình luận...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    context.read<VideoViewModel>().postComment(widget.listingId, _controller.text);
                    _controller.clear();
                    // Ẩn bàn phím
                    FocusScope.of(context).unfocus();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}