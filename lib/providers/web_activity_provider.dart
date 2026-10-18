import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/web_activity_model.dart';
import '../data/repositories/parent_repository.dart';

class WebActivityProvider extends ChangeNotifier {
  final ParentRepository _repository = ParentRepository();

  List<WebActivityModel> _activities = [];
  bool _isLoading = true;
  StreamSubscription? _sub;

  List<WebActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;

  void init(String childId) {
    _isLoading = true;
    notifyListeners();

    _sub?.cancel();
    _sub = _repository.streamWebActivity(childId).listen((list) {
      _activities = list;
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
