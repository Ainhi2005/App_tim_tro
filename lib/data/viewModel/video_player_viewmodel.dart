import 'package:flutter/material.dart';
import '../models/video_review_item.dart'; // Import model của bạn
import 'package:video_player/video_player.dart';


/// ViewModel này quản lý TRẠNG THÁI cho màn hình player
/// Nó quản lý PageController (để vuốt) và VideoPlayerController (để phát)
class VideoPlayerViewModel extends ChangeNotifier {
  final List<VideoReviewItem> reviews;
  final int initialIndex;

  // --- Controllers lõi ---
  late PageController pageController;
  VideoPlayerController? _videoController;

  // --- Biến trạng thái (State) ---
  int _currentIndex;
  bool _isLoading = true; // Bắt đầu bằng loading
  bool _isPlaying = true;

  // --- Getters cho View ---
  VideoPlayerController? get videoController => _videoController;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;

  /// Constructor: Nhận danh sách video và vị trí bắt đầu
  VideoPlayerViewModel({
    required this.reviews,
    required this.initialIndex,
  }) : _currentIndex = initialIndex {
    pageController = PageController(initialPage: initialIndex);
    // Bắt đầu tải video đầu tiên
    _initializeVideo(initialIndex);
  }

  /// 1. HÀM LÕI: Tải và phát video tại một vị trí
  Future<void> _initializeVideo(int index) async {
    _isLoading = true;
    _isPlaying = true; // Mặc định là phát khi video mới tải
    notifyListeners();

    // 1. Hủy controller CŨ (nếu có) để giải phóng bộ nhớ
    await _videoController?.dispose();

    // 2. Lấy URL và tạo controller MỚI
    final videoUrl = reviews[index].videoUrl;
    if (videoUrl.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _videoController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));

    try {
      // 3. Khởi tạo, bật lặp lại (loop), và phát
      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!.play();
      _isLoading = false;
    } catch (e) {
      print("Lỗi khi tải video: $e");
      _isLoading = false;
      // TODO: Thêm state lỗi để hiển thị trên UI
    }

    // Báo cho View biết video đã sẵn sàng, hãy hiển thị nó
    notifyListeners();
  }

  /// 2. HÀM CÔNG KHAI: Được gọi bởi View khi người dùng vuốt trang
  void onPageChanged(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;

    // Tải video cho trang mới
    _initializeVideo(index);
  }

  /// 3. HÀM CÔNG KHAI: Được gọi bởi View khi người dùng nhấn màn hình
  void togglePlayPause() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return;
    }

    if (_videoController!.value.isPlaying) {
      _videoController!.pause();
      _isPlaying = false;
    } else {
      _videoController!.play();
      _isPlaying = true;
    }
    notifyListeners(); // Báo cho UI (nếu có icon Play/Pause) cập nhật
  }

  /// 4. HÀM DỌN DẸP: Rất quan trọng
  @override
  void dispose() {
    _videoController?.dispose(); // Hủy video controller cuối cùng
    pageController.dispose();
    super.dispose();
  }
}