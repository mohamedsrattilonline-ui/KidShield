import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/child_device_model.dart';
import '../data/models/pairing_code_model.dart';
import '../data/repositories/parent_repository.dart';
import '../data/repositories/pairing_repository.dart';

class ParentDashboardProvider extends ChangeNotifier {
  final ParentRepository _parentRepository = ParentRepository();
  final PairingRepository _pairingRepository = PairingRepository();

  List<ChildDeviceModel> _children = [];
  ChildDeviceModel? _selectedChild;
  bool _isLoading = true;
  StreamSubscription? _childrenSub;

  PairingCodeModel? _activePairingCode;
  bool _isGeneratingCode = false;

  List<ChildDeviceModel> get children => _children;
  ChildDeviceModel? get selectedChild => _selectedChild;
  bool get isLoading => _isLoading;
  PairingCodeModel? get activePairingCode => _activePairingCode;
  bool get isGeneratingCode => _isGeneratingCode;

  void init(String parentId) {
    _isLoading = true;
    notifyListeners();

    _childrenSub?.cancel();
    _childrenSub = _parentRepository.streamChildren(parentId).listen((list) {
      _children = list;
      _isLoading = false;

      if (_selectedChild != null) {
        final updated = list.where((c) => c.childId == _selectedChild!.childId);
        if (updated.isNotEmpty) {
          _selectedChild = updated.first;
        }
      } else if (list.isNotEmpty) {
        _selectedChild = list.first;
      }

      notifyListeners();
    });
  }

  void selectChild(ChildDeviceModel child) {
    _selectedChild = child;
    notifyListeners();
  }

  Future<PairingCodeModel> generateNewPairingCode({
    required String parentId,
    required String childTempName,
  }) async {
    _isGeneratingCode = true;
    notifyListeners();

    final code = await _pairingRepository.createPairingCode(
      parentId: parentId,
      childTempName: childTempName,
    );

    _activePairingCode = code;
    _isGeneratingCode = false;
    notifyListeners();
    return code;
  }

  void clearActivePairingCode() {
    _activePairingCode = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _childrenSub?.cancel();
    super.dispose();
  }
}
