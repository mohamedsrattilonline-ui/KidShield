import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../providers/app_mode_provider.dart';
import '../../../../providers/child_telemetry_provider.dart';
import '../widgets/sos_button_widget.dart';
import 'child_pairing_screen.dart';
import 'device_locked_screen.dart';

class ChildDashboardScreen extends StatelessWidget {
  const ChildDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final childProv = Provider.of<ChildTelemetryProvider>(context);
    final modeProv = Provider.of<AppModeProvider>(context);

    // If device is not yet paired, redirect to pairing
    if (!childProv.isPaired) {
      return const ChildPairingScreen();
    }

    // If bedtime or screen time lock is active, show locked overlay
    if (childProv.isDeviceLocked) {
      return const DeviceLockedScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(childProv.childName ?? l10n.translate('childDashboardTitle')),
        leading: IconButton(
          icon: const Icon(Icons.swap_horiz_rounded),
          tooltip: l10n.translate('switchMode'),
          onPressed: () => modeProv.resetToOnboarding(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.translate('switchLanguage'),
            onPressed: () => modeProv.toggleLanguage(),
          ),
          IconButton(
            icon: const Icon(Icons.link_off_rounded),
            tooltip: 'Unpair',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Unpair Device?'),
                  content: const Text('Are you sure you want to unpair this child device?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.sosRed),
                      child: const Text('Unpair', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await childProv.unpairDevice();
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Active Protection Shield Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.shieldLightGreen,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.shieldGreen.withOpacity(0.5), width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.verified_user_rounded,
                          color: AppColors.shieldGreen,
                          size: 26,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.translate('deviceProtected'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.shieldGreen,
                              ),
                            ),
                            Text(
                              l10n.translate('protectionActiveDesc'),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.green.shade900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),

                  // Prominent SOS Emergency Button
                  SosButtonWidget(
                    onTrigger: () {
                      childProv.triggerEmergencySos();
                    },
                  ),
                  const SizedBox(height: 40),

                  // Telemetry Status Indicators (Battery & GPS)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Battery Status
                        Row(
                          children: [
                            Icon(
                              childProv.isCharging
                                  ? Icons.battery_charging_full_rounded
                                  : Icons.battery_std_rounded,
                              color: childProv.currentBatteryLevel > 20
                                  ? AppColors.shieldGreen
                                  : AppColors.sosRed,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.translate('batteryLevel'),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                                Text(
                                  '${childProv.currentBatteryLevel}%',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(height: 30, width: 1, color: Colors.grey.shade300),
                        // GPS Status
                        Row(
                          children: [
                            const Icon(
                              Icons.gps_fixed_rounded,
                              color: AppColors.primaryBlue,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.translate('gpsStatus'),
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                                Text(
                                  l10n.translate('active'),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.shieldGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
