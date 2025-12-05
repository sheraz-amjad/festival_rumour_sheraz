import 'package:flutter/material.dart';
import '../../../core/viewmodels/base_view_model.dart';

class NotificationViewModel extends BaseViewModel {
  List<NotificationItem> notifications = [];

  @override
  void init() {
    super.init();
    _loadNotifications();
  }

  void _loadNotifications() {
    notifications = [
      NotificationItem(
        id: '1',
        title: 'Welcome to Festival Rumour! 🎉',
        message: 'Your account has been successfully created. Start exploring festivals near you.',
        time: '2 hours ago',
        isRead: false,
        type: NotificationType.welcome,
        icon: Icons.celebration,
        iconColor: 0xFF4CAF50,
      ),
      NotificationItem(
        id: '2',
        title: 'New Festival Alert! 🎵',
        message: 'Luna Fest 2024 is happening this weekend. Don\'t miss out on the amazing lineup!',
        time: '4 hours ago',
        isRead: false,
        type: NotificationType.festival,
        icon: Icons.music_note,
        iconColor: 0xFF2196F3,
      ),
      NotificationItem(
        id: '3',
        title: 'Friend Request 📱',
        message: 'Sarah Johnson wants to connect with you on Festival Rumour.',
        time: '6 hours ago',
        isRead: true,
        type: NotificationType.social,
        icon: Icons.person_add,
        iconColor: 0xFF9C27B0,
      ),
      NotificationItem(
        id: '4',
        title: 'Event Reminder ⏰',
        message: 'Luna Fest 2024 starts in 2 hours. Get ready for an amazing experience!',
        time: '1 day ago',
        isRead: true,
        type: NotificationType.reminder,
        icon: Icons.schedule,
        iconColor: 0xFFFF9800,
      ),
      NotificationItem(
        id: '5',
        title: 'New Chat Message 💬',
        message: 'You have 3 new messages in the Luna Fest group chat.',
        time: '2 days ago',
        isRead: true,
        type: NotificationType.chat,
        icon: Icons.chat_bubble,
        iconColor: 0xFF00BCD4,
      ),
      NotificationItem(
        id: '6',
        title: 'Festival Update 📢',
        message: 'The lineup for Electric Dreams Festival has been updated. Check out the new artists!',
        time: '3 days ago',
        isRead: true,
        type: NotificationType.update,
        icon: Icons.update,
        iconColor: 0xFF607D8B,
      ),
      NotificationItem(
        id: '7',
        title: 'Photo Uploaded 📸',
        message: 'Your photo from Luna Fest has been approved and is now visible to others.',
        time: '1 week ago',
        isRead: true,
        type: NotificationType.photo,
        icon: Icons.photo_camera,
        iconColor: 0xFFE91E63,
      ),
    ];
    notifyListeners();
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final bool isRead;
  final NotificationType type;
  final IconData icon;
  final int iconColor;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.type,
    required this.icon,
    required this.iconColor,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    String? time,
    bool? isRead,
    NotificationType? type,
    IconData? icon,
    int? iconColor,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
    );
  }
}

enum NotificationType {
  welcome,
  festival,
  social,
  reminder,
  chat,
  update,
  photo,
}


