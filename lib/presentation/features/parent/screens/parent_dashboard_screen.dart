import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../providers/app_mode_provider.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/parent_dashboard_provider.dart';
import '../../../../providers/sos_alert_provider.dart';
import '../widgets/child_status_card.dart';
import '../widgets/sos_alert_dialog.dart';
import 'device_pairing_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final parentId = auth.user?.uid ?? 'parent_user_01';

      Provider.of<ParentDashboardProvider>(context, listen: false).init(parentId);
      Provider.of<SosAlertProvider>(context, listen: false).init(parentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final modeProv = Provider.of<AppModeProvider>(context);
    final dashProv = Provider.of<ParentDashboardProvider>(context);
    final sosProv = Provider.of<SosAlertProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(l10n.translate('dashboard')),
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
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.signOut();
              if (context.mounted) {
                modeProv.resetToOnboarding();
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const DevicePairingScreen()),
          );
        },
        backgroundColor: AppColors.primaryBlue,
        icon: const Icon(Icons.add_link, color: Colors.white),
        label: Text(
          l10n.translate('addChild'),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            final parentId = auth.user?.uid ?? 'parent_user_01';
            dashProv.init(parentId);
          },
          child: Column(
            children: [
              // High-priority SOS Alert notification if any child triggered emergency
              if (sosProv.currentDisplayedAlert != null)
                SosAlertOverlayWidget(alert: sosProv.currentDisplayedAlert!),

              // Main Children List or Empty State
              Expanded(
                child: dashProv.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : dashProv.children.isEmpty
                        ? _buildEmptyState(context, l10n)
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 8, bottom: 80),
                            itemCount: dashProv.children.length,
                            itemBuilder: (context, index) {
                              final child = dashProv.children[index];
                              return ChildStatusCard(child: child);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.child_care_rounded,
                size: 44,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.translate('noChildrenYet'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.translate('noChildrenDesc'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DevicePairingScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.qr_code_2_rounded),
              label: Text(l10n.translate('addChild')),
            ),
          ],
        ),
      ),
    );
  }
}
