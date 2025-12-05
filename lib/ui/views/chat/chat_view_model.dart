import 'package:flutter/material.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';

class ChatViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  
  int _selectedTab = 0; // 0 = Public, 1 = Private
  bool _isInChatRoom = false;
  Map<String, dynamic>? _currentChatRoom;

  int get selectedTab => _selectedTab;
  bool get isInChatRoom => _isInChatRoom;
  Map<String, dynamic>? get currentChatRoom => _currentChatRoom;

  void setSelectedTab(int tab) {
    _selectedTab = tab;
    notifyListeners();
  }

  // Mock chat rooms data
  final List<Map<String, dynamic>> _chatRooms = [
    {
      'title': AppStrings.lunaFest,
      'subtitle': AppStrings.communityRoom,
      'image': AppAssets.post,
      'members': 156,
    },
    {
      'title': AppStrings.musicFestival,
      'subtitle': AppStrings.privateRoom,
      'image': AppAssets.post,
      'members': 89,
    },
    {
      'title': AppStrings.artCulture,
      'subtitle': AppStrings.communityRoom,
      'image': AppAssets.post,
      'members': 234,
    },
    {
      'title': AppStrings.foodDrinks,
      'subtitle': AppStrings.communityRoom,
      'image': AppAssets.post,
      'members': 178,
    },
    {
      'title': AppStrings.photography,
      'subtitle': AppStrings.privateRoom,
      'image': AppAssets.post,
      'members': 67,
    },
  ];

  List<Map<String, dynamic>> get chatRooms {
    if (_selectedTab == 0) {
      // Public rooms
      return _chatRooms.where((room) => room['subtitle'].contains(AppStrings.communityRoom)).toList();
    } else {
      // Private rooms
      return _chatRooms.where((room) => room['subtitle'].contains(AppStrings.privateRoom)).toList();
    }
  }

  // Private chat conversations
  final List<Map<String, dynamic>> _privateChats = [
    {
      'name': AppStrings.luna,
      'avatar': AppAssets.profile,
      'lastMessage': AppStrings.chuturCongratulations,
      'timestamp': AppStrings.timestamp2108,
      'unreadCount': 4,
      'isActive': true,
    },
    {
      'name': AppStrings.luna2,
      'avatar': AppAssets.profile,
      'lastMessage': AppStrings.tarunSendMeCssNotes,
      'timestamp': AppStrings.timestamp2045,
      'unreadCount': 0,
      'isActive': true,
    },
  ];

  List<Map<String, dynamic>> get privateChats => _privateChats;

  void joinRoom(Map<String, dynamic> room) {
    // Handle join room action
    print("${AppStrings.joiningRoom}${room['title']}");
  }

  void addPrivateChat(String title, List<String> participants) {
    // Add new private chat to the list
    final newChat = {
      'name': title,
      'avatar': AppAssets.profile,
      'lastMessage': AppStrings.chatCreated,
      'timestamp': _getCurrentTime(),
      'unreadCount': 0,
      'isActive': true,
    };
    
    _privateChats.insert(0, newChat);
    notifyListeners();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  List<Map<String, dynamic>> chatRooms1 = [
    {
      'name': 'Luna Festival Community',
      'image': AppAssets.post,
    },
    {
      'name': 'Luna Festival Community',
      'image': AppAssets.post,
    },

  ];

  // Chat room functionality
  TextEditingController messageController = TextEditingController();

  void enterChatRoom(Map<String, dynamic> room) {
    _currentChatRoom = room;
    _isInChatRoom = true;
    notifyListeners();
  }

  void exitChatRoom() {
    _isInChatRoom = false;
    _currentChatRoom = null;
    messageController.clear();
    notifyListeners();
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      // Handle sending message
      print("${AppStrings.sendingMessage}${messageController.text}");
      messageController.clear();
      notifyListeners();
    }
  }

  void inviteFriends() {
    // Handle invite friends action
    print(AppStrings.invitingFriendsToChatRoom);
  }

  // Navigation methods
  void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  void navigateToChatRoom(Map<String, dynamic> room) {
    _currentChatRoom = room;
    _isInChatRoom = true;
    notifyListeners();
  }

  void navigateBackFromChatRoom() {
    _isInChatRoom = false;
    _currentChatRoom = null;
    messageController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
