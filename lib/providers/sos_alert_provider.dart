import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/audio_alert_service.dart';
import '../data/models/sos_alert_model.dart';
import '../data/repositories/parent_repository.dart';

class SosAlertProvider extends ChangeNotifier {
  final ParentRepository _repository = ParentRepository();

  List<SosAlertModel> _activeAlerts = [];
  SosAlertModel? _currentDisplayedAlert;
  StreamSubscription? _alertSub;

  List<SosAlertModel> get activeAlerts => _activeAlerts;
  SosAlertModel? get currentDisplayedAlert => _currentDisplayedAlert;
  bool get hasActiveAlert => _activeAlerts.isNotEmpty;

  void init(String parentId) {
    _alertSub?.cancel();
    _alertSub = _repository.streamSosAlerts(parentId).listen((alerts) {
      _activeAlerts = alerts;

      if (alerts.isNotEmpty) {
        // High-priority emergency detected
        _currentDisplayedAlert = alerts.first;
        AudioAlertService.playEmergencySiren();
      } else {
        _currentDisplayedAlert = null;
        AudioAlertService.stopEmergencySiren();
      }
      notifyListeners();
    });
  }

  Future<void> acknowledgeAndSilenceAlert(String alertId) async {
    await AudioAlertService.stopEmergencySiren();
    await _repository.resolveSosAlert(alertId);
    _activeAlerts.removeWhere((a) => a.alertId == alertId);
    if (_currentDisplayedAlert?.alertId == alertId) {
      _currentDisplayedAlert = null;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _alertSub?.cancel();
    AudioAlertService.stopEmergencySiren();
    super.dispose();
  }
}
