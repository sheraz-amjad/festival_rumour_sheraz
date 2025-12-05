import 'package:flutter/material.dart';

import '../../../core/viewmodels/base_view_model.dart';
import 'toilet_view.dart';

class ToiletViewModel extends BaseViewModel {
  List<ToiletItem> _toilets = [];
  bool _showToiletDetail = false;
  ToiletItem? _selectedToilet;

  List<ToiletItem> get toilets => _toilets;
  bool get showToiletDetail => _showToiletDetail;
  ToiletItem? get selectedToilet => _selectedToilet;

  @override
  void init() {
    super.init();
    _loadToilets();
  }

  void _loadToilets() {
    _toilets = [
      ToiletItem(
        name: 'Femme Fatal',
        description: 'Red themed toilet',
        color: Colors.red,
      ),
      ToiletItem(
        name: 'Pretty In Pink Tardis',
        description: 'Pink themed toilet',
        color: Colors.pink,
      ),
      ToiletItem(
        name: 'Long Drop',
        description: 'Outdoor rustic toilet',
        color: const Color(0xFF8B4513), // Brown color
      ),
      ToiletItem(
        name: 'China Blue Royal Flush',
        description: 'Blue modern portable toilet',
        color: Colors.blue,
      ),
    ];
    notifyListeners();
  }

  void addToilet(ToiletItem toilet) {
    _toilets.add(toilet);
    notifyListeners();
  }

  void removeToilet(int index) {
    if (index >= 0 && index < _toilets.length) {
      _toilets.removeAt(index);
      notifyListeners();
    }
  }

  void set showToiletDetail(bool value) {
    _showToiletDetail = value;
    notifyListeners();
  }

  void set selectedToilet(ToiletItem? toilet) {
    _selectedToilet = toilet;
    notifyListeners();
  }
  // void navigateBack(BuildContext context) {
  //   Navigator.pop(context);
  // }

  void navigateToDetail(ToiletItem toilet) {
    _selectedToilet = toilet;
    _showToiletDetail = true;
    notifyListeners();
  }

  void navigateBackToList() {
    _showToiletDetail = false;
    notifyListeners();
  }

}
