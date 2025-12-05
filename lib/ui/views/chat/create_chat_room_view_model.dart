import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/viewmodels/base_view_model.dart';
import '../../../core/router/app_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/di/locator.dart';
import '../../../core/services/navigation_service.dart';
import 'package:share_plus/share_plus.dart';


class CreateChatRoomViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final TextEditingController titleController = TextEditingController();

  List<Contact> _allContacts = [];
  List<Contact> _festivalContacts = [];
  List<Contact> _nonFestivalContacts = [];
  Set<String> _selectedContacts = {};

  // Contact data for UI
  List<Map<String, dynamic>> _festivalContactData = [];
  List<Map<String, dynamic>> _nonFestivalContactData = [];

  // Mock data for festival participants (normally from backend)
  final Set<String> _festivalParticipants = {
    AppStrings.robertFox,
    AppStrings.darrellSteward,
    AppStrings.ronaldRichards,
    AppStrings.marvinMcKinney
  };

  // Mock contacts for fallback/demo mode
  final List<Map<String, dynamic>> _mockContacts = [
    {
      'name': AppStrings.robertFox,
      'phone': AppStrings.phone0123456789,
      'isFestival': true,
    },
  ];

  List<Contact> get allContacts => _allContacts;
  List<Contact> get festivalContacts => _festivalContacts;
  List<Contact> get nonFestivalContacts => _nonFestivalContacts;
  Set<String> get selectedContacts => _selectedContacts;

  List<Map<String, dynamic>> get festivalContactData => _festivalContactData;
  List<Map<String, dynamic>> get nonFestivalContactData => _nonFestivalContactData;

  @override
  void init() {
    super.init();
    _loadContacts();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  /// Load contacts from device or create mock contacts if unavailable
  Future<void> _loadContacts() async {
    await handleAsync(() async {
      final permission = await Permission.contacts.request();

      if (permission.isGranted) {
        print("✅ Contacts permission granted");

        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );

        if (contacts.isNotEmpty) {
          _allContacts = contacts;
          print("📇 Loaded ${contacts.length} contacts from device");
        } else {
          // Fallback to mock if device has no contacts
          print("⚠️ No device contacts found, using mock contacts");
          _createMockContacts();
        }

        _filterContacts();
        notifyListeners();
      } else {
        print("❌ Contacts permission denied");
        setError(AppStrings.contactsPermissionDenied);
      }
    }, errorMessage: AppStrings.failedToLoadContacts);
  }

  /// Create mock contacts if no real contacts available
  void _createMockContacts() {
    _allContacts.clear();

    for (final mockContact in _mockContacts) {
      final contact = Contact(
        id: mockContact['name'].hashCode.toString(),
        displayName: mockContact['name'],
        phones: [Phone(mockContact['phone'])],
      );
      _allContacts.add(contact);
    }
  }

  /// Separate festival and non-festival contacts
  void _filterContacts() {
    _festivalContacts.clear();
    _nonFestivalContacts.clear();
    _festivalContactData.clear();
    _nonFestivalContactData.clear();

    for (final contact in _allContacts) {
      final displayName = contact.displayName ?? '';

      final isFestival = _festivalParticipants.contains(displayName);

      final contactData = {
        'id': contact.id,
        'name': displayName,
        'phone': contact.phones.isNotEmpty ? contact.phones.first.number : '',
        'isFestival': isFestival,
      };

      if (isFestival) {
        _festivalContacts.add(contact);
        _festivalContactData.add(contactData);
      } else {
        _nonFestivalContacts.add(contact);
        _nonFestivalContactData.add(contactData);
      }
    }

    print(
      "🎉 Festival Contacts: ${_festivalContacts.length}, Non-Festival: ${_nonFestivalContacts.length}",
    );
  }

  void toggleContactSelection(String contactId) {
    if (_selectedContacts.contains(contactId)) {
      _selectedContacts.remove(contactId);
    } else {
      _selectedContacts.add(contactId);
    }
    notifyListeners();
  }

  bool isContactSelected(String contactId) {
    return _selectedContacts.contains(contactId);
  }

  void createChatRoom() {
    if (titleController.text.trim().isEmpty) {
      setError(AppStrings.pleaseEnterChatRoomTitle);
      return;
    }

    if (_selectedContacts.isEmpty) {
      setError(AppStrings.pleaseSelectAtLeastOneContact);
      return;
    }

    print('${AppStrings.creatingChatRoom}${titleController.text}');
    print('${AppStrings.selectedContacts}$_selectedContacts');

    setError(null);
    _navigationService.navigateTo(AppRoutes.chatRoom);
  }

  void refreshContacts() {
    _loadContacts();
  }
  void inviteContact(String contactName, String phoneNumber) async {
    try {
      final inviteMessage = '''
Hey $contactName 👋,

I'm using LunaFest to chat and connect during festivals! 🎉  
Join me here 👉 [https://festivalrumour.com]

See you on LunaFest!
''';

      await Share.share(
        inviteMessage,
        subject: 'Join me on LunaFest 🎊',
      );

      print('✅ Invite sent to $contactName');
      setError(null);
    } catch (e) {
      print('❌ Error sharing invite: $e');
      setError('Failed to send invite');
    }
  }
}
