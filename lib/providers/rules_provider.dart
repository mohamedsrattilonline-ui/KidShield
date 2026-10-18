import 'package:flutter/material.dart';
import '../data/models/rules_model.dart';
import '../data/repositories/parent_repository.dart';

class RulesProvider extends ChangeNotifier {
  final ParentRepository _repository = ParentRepository();

  RulesModel? _rules;
  bool _isLoading = false;
  bool _isSaving = false;

  RulesModel? get rules => _rules;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> loadRules(String childId) async {
    _isLoading = true;
    notifyListeners();

    _rules = await _repository.getChildRules(childId);
    _isLoading = false;
    notifyListeners();
  }

  void updateDailyLimit(int minutes) {
    if (_rules == null) return;
    _rules = _rules!.copyWith(dailyLimitMinutes: minutes);
    notifyListeners();
  }

  void toggleBedtimeEnabled(bool enabled) {
    if (_rules == null) return;
    _rules = _rules!.copyWith(isBedtimeEnabled: enabled);
    notifyListeners();
  }

  void updateBedtimeHours(String start, String end) {
    if (_rules == null) return;
    _rules = _rules!.copyWith(bedtimeStart: start, bedtimeEnd: end);
    notifyListeners();
  }

  Future<void> toggleInstantLock(bool lock) async {
    if (_rules == null) return;
    _rules = _rules!.copyWith(isRemoteLocked: lock);
    notifyListeners();
    await saveRules();
  }

  // Web Filtering & Safety Toggles
  void toggleWebFiltering(bool enabled) {
    if (_rules == null) return;
    _rules = _rules!.copyWith(isWebFilteringEnabled: enabled);
    notifyListeners();
  }

  void toggleBlockAdultContent(bool enabled) {
    if (_rules == null) return;
    _rules = _rules!.copyWith(blockAdultContent: enabled);
    notifyListeners();
  }

  void toggleLogWebHistory(bool enabled) {
    if (_rules == null) return;
    _rules = _rules!.copyWith(logWebHistory: enabled);
    notifyListeners();
  }

  Future<bool> saveRules() async {
    if (_rules == null) return false;
    _isSaving = true;
    notifyListeners();

    try {
      await _repository.updateChildRules(_rules!);
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }
}
