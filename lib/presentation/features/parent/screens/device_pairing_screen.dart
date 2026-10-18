import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/parent_dashboard_provider.dart';

class DevicePairingScreen extends StatefulWidget {
  const DevicePairingScreen({super.key});

  @override
  State<DevicePairingScreen> createState() => _DevicePairingScreenState();
}

class _DevicePairingScreenState extends State<DevicePairingScreen> {
  final _childNameController = TextEditingController(text: 'Sarah');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateCode();
    });
  }

  @override
  void dispose() {
    _childNameController.dispose();
    super.dispose();
  }

  void _generateCode() {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final dash = Provider.of<ParentDashboardProvider>(context, listen: false);
    final parentId = auth.user?.uid ?? 'parent_user_01';
    final childName = _childNameController.text.trim();

    dash.generateNewPairingCode(
      parentId: parentId,
      childTempName: childName.isNotEmpty ? childName : 'Child Device',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dash = Provider.of<ParentDashboardProvider>(context);
    final activeCode = dash.activePairingCode;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(l10n.translate('pairNewDevice')),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Child Name Input
                    TextField(
                      controller: _childNameController,
                      decoration: InputDecoration(
                        labelText: l10n.translate('enterChildName'),
                        prefixIcon: const Icon(Icons.child_care),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          tooltip: l10n.translate('generateNewCode'),
                          onPressed: _generateCode,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Instruction Header
                    Text(
                      l10n.translate('pairInstruction'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 6-Digit PIN Display
                    if (dash.isGeneratingCode || activeCode == null)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      // Individual Styled Digit Boxes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: activeCode.code.split('').map((digit) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 44,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryBlue,
                                width: 1.8,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              digit,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDarkBlue,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // QR Code Rendering
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: activeCode.code,
                            version: QrVersions.auto,
                            size: 180.0,
                            gapless: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Expiry Warning
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer_outlined, size: 16, color: Colors.grey.shade600),
                          const SizedBox(width: 4),
                          Text(
                            '${l10n.translate("pairingCodeExpiresIn")} 15 ${l10n.translate("minutes")}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Re-generate Button
                      OutlinedButton.icon(
                        onPressed: _generateCode,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text(l10n.translate('generateNewCode')),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
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
