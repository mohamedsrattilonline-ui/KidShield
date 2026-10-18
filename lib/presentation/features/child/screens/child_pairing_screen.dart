import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../providers/app_mode_provider.dart';
import '../../../../providers/child_telemetry_provider.dart';
import 'child_dashboard_screen.dart';

class ChildPairingScreen extends StatefulWidget {
  const ChildPairingScreen({super.key});

  @override
  State<ChildPairingScreen> createState() => _ChildPairingScreenState();
}

class _ChildPairingScreenState extends State<ChildPairingScreen> {
  final _pinController = TextEditingController();
  final _nameController = TextEditingController(text: 'Sarah');

  @override
  void dispose() {
    _pinController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submitPairing() async {
    final pin = _pinController.text.trim();
    final name = _nameController.text.trim();
    final l10n = AppLocalizations.of(context);

    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('enterPinCode')),
          backgroundColor: AppColors.sosRed,
        ),
      );
      return;
    }

    final childProv =
        Provider.of<ChildTelemetryProvider>(context, listen: false);
    final success = await childProv.pairWithPin(
      pin: pin,
      customChildName: name,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('pairingSuccess')),
          backgroundColor: AppColors.shieldGreen,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ChildDashboardScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(childProv.pairingError ?? l10n.translate('invalidCode')),
          backgroundColor: AppColors.sosRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final childProv = Provider.of<ChildTelemetryProvider>(context);
    final modeProv = Provider.of<AppModeProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(l10n.translate('childPairingTitle')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => modeProv.resetToOnboarding(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => modeProv.toggleLanguage(),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.shieldGreen.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.phonelink_lock_rounded,
                          size: 42,
                          color: AppColors.shieldGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.translate('childPairingTitle'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.translate('childPairingSubtitle'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Child Name input
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.translate('enterChildName'),
                        prefixIcon: const Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 6-digit PIN input
                    TextField(
                      controller: _pinController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        letterSpacing: 8,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryDarkBlue,
                      ),
                      decoration: InputDecoration(
                        labelText: l10n.translate('enterPinCode'),
                        prefixIcon: const Icon(Icons.pin),
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Link Device Button
                    ElevatedButton(
                      onPressed: childProv.isPairing ? null : _submitPairing,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.shieldGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: childProv.isPairing
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              l10n.translate('confirmLink'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
