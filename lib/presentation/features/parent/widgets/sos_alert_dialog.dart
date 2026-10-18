import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../data/models/child_device_model.dart';
import '../../../../data/models/sos_alert_model.dart';
import '../../../../providers/sos_alert_provider.dart';
import '../screens/live_map_screen.dart';

class SosAlertOverlayWidget extends StatelessWidget {
  final SosAlertModel alert;

  const SosAlertOverlayWidget({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final sosProv = Provider.of<SosAlertProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.sosLightRed,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sosRed, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.sosRed.withOpacity(0.25),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with pulsing alert icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.sosRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.translate('sosAlertReceived'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.sosDarkRed,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${alert.childName} ${l10n.translate('sosFromChild')}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Details chip: Location coordinates & battery
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: AppColors.sosRed),
                        const SizedBox(width: 4),
                        Text(
                          '${alert.latitude.toStringAsFixed(4)}, ${alert.longitude.toStringAsFixed(4)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.battery_alert, size: 16, color: AppColors.warningOrange),
                        const SizedBox(width: 4),
                        Text(
                          '${alert.batteryLevel}%',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Action Buttons: View on Map & Silence/Dismiss
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        final childProxy = ChildDeviceModel(
                          childId: alert.childId,
                          parentId: alert.parentId,
                          childName: alert.childName,
                          deviceName: 'Device',
                          platform: 'mobile',
                          latitude: alert.latitude,
                          longitude: alert.longitude,
                          accuracy: 5.0,
                          batteryLevel: alert.batteryLevel,
                          isCharging: false,
                          isOnline: true,
                          isBedtimeLocked: false,
                          lastPingAt: alert.timestamp,
                        );
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LiveMapScreen(child: childProxy),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.sosRed),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.map, size: 16, color: AppColors.sosRed),
                      label: Text(
                        l10n.translate('liveLocation'),
                        style: const TextStyle(
                          color: AppColors.sosRed,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        sosProv.acknowledgeAndSilenceAlert(alert.alertId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sosRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.volume_off, size: 16),
                      label: Text(
                        l10n.translate('dismissAlert'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
