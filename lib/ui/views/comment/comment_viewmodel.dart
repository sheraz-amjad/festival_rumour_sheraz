import 'package:flutter/material.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/di/locator.dart';

class CommentViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  TextEditingController commentController = TextEditingController();
  bool _showEmojiGrid = false;

  List<String> emojis = [
    "😀", "😂", "😍", "👍", "👏", "😢", "🔥", "❤️"
  ];

  bool get showEmojiGrid => _showEmojiGrid;

  void showEmojiKeyboard() {
    _showEmojiGrid = true;
    notifyListeners();
  }

  void hideEmojiKeyboard() {
    _showEmojiGrid = false;
    notifyListeners();
  }

  void insertEmoji(String emoji) {
    commentController.text += emoji;
    commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: commentController.text.length),
    );
    notifyListeners();
  }

  void postComment() {
    print("Comment posted: ${commentController.text}");
    commentController.clear();
    hideEmojiKeyboard();
  }

  void closeCommentView() {
    // Close the comment view and return to previous screen
    _navigationService.pop();
  }

  @override
  void onDispose() {
    commentController.dispose();
    super.onDispose();
  }
}
