import 'package:flutter/material.dart';

class SearchData extends ChangeNotifier{
  bool _showSearchField = false;
  String _searchTerm = "";

  bool get showSearchField => _showSearchField;

  set showSearchField(bool value) {
    _showSearchField = value;
    notifyListeners();
  }

  String get searchTerm => _searchTerm;

  set searchTerm(String value) {
    _searchTerm = value;
    notifyListeners();
  }

  clearSearch(){
    _showSearchField= false;
    _searchTerm = "";
  }
}