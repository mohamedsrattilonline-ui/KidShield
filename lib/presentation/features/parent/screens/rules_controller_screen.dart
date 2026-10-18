import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../data/models/child_device_model.dart';
import '../../../../providers/rules_provider.dart';
import 'web_activity_log_screen.dart';


class RulesControllerScreen extends StatefulWidget {
  final ChildDeviceModel child;

  const RulesControllerScreen({super.key, required this.child});

  @override
  State<RulesControllerScreen> createState() => _RulesControllerScreenState();
}

class _RulesControllerScreenState extends State<RulesControllerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RulesProvider>(context, listen: false)
          .loadRules(widget.child.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rulesProv = Provider.of<RulesProvider>(context);
    final rules = rulesProv.rules;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text('${widget.child.childName} - ${l10n.translate("screenTimeSettings")}'),
      ),
      body: rulesProv.isLoading || rules == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Section 1: Instant Remote Lock
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: SwitchListTile(
                          contentPadding: const EdgeInsets.all(16),
                          activeColor: AppColors.sosRed,
                          secondary: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: rules.isRemoteLocked
                                  ? AppColors.sosLightRed
                                  : Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_rounded,
                              color: rules.isRemoteLocked
                                  ? AppColors.sosRed
                                  : Colors.grey.shade600,
                            ),
                          ),
                          title: Text(
                            l10n.translate('remoteInstantLock'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            l10n.translate('remoteInstantLockDesc'),
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: rules.isRemoteLocked,
                          onChanged: (val) {
                            rulesProv.toggleInstantLock(val);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Section 2: Daily Screen Time Limit Slider
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.hourglass_top_rounded,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.translate('dailyLimit'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${(rules.dailyLimitMinutes / 60).toStringAsFixed(1)} ${l10n.translate("hours")} (${rules.dailyLimitMinutes} ${l10n.translate("minutes")})',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.primaryBlue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Slider(
                                value: rules.dailyLimitMinutes.toDouble(),
                                min: 30,
                                max: 360,
                                divisions: 11, // in 30 min increments
                                activeColor: AppColors.primaryBlue,
                                label: '${(rules.dailyLimitMinutes / 60).toStringAsFixed(1)}h',
                                onChanged: (val) {
                                  rulesProv.updateDailyLimit(val.toInt());
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('30 ${l10n.translate("minutes")}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                  Text('6 ${l10n.translate("hours")}',
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Section 3: Bedtime Lock Scheduler
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.bedtimePurple.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.bedtime_rounded,
                                      color: AppColors.bedtimePurple,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.translate('bedtimeLock'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          l10n.translate('bedtimeLockDesc'),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    activeColor: AppColors.bedtimePurple,
                                    value: rules.isBedtimeEnabled,
                                    onChanged: (val) {
                                      rulesProv.toggleBedtimeEnabled(val);
                                    },
                                  ),
                                ],
                              ),
                              if (rules.isBedtimeEnabled) ...[
                                const SizedBox(height: 20),
                                const Divider(height: 1),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.translate('bedtimeSchedule'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _TimeBox(
                                        label: l10n.translate('from'),
                                        time: rules.bedtimeStart,
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(hour: 21, minute: 0),
                                          );
                                          if (picked != null) {
                                            final formatted =
                                                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                            rulesProv.updateBedtimeHours(
                                                formatted, rules.bedtimeEnd);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _TimeBox(
                                        label: l10n.translate('to'),
                                        time: rules.bedtimeEnd,
                                        onTap: () async {
                                          final picked = await showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(hour: 7, minute: 0),
                                          );
                                          if (picked != null) {
                                            final formatted =
                                                '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                            rulesProv.updateBedtimeHours(
                                                rules.bedtimeStart, formatted);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Section 4: Web Safety & Inappropriate Content Filtering
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.security_rounded,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.translate('webSafetySettings'),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          l10n.translate('enableWebFilteringDesc'),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    activeColor: Colors.teal,
                                    value: rules.isWebFilteringEnabled,
                                    onChanged: (val) {
                                      rulesProv.toggleWebFiltering(val);
                                    },
                                  ),
                                ],
                              ),
                              if (rules.isWebFilteringEnabled) ...[
                                const SizedBox(height: 16),
                                const Divider(height: 1),
                                const SizedBox(height: 12),

                                // Optional Adult Content Block Toggle
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: AppColors.sosRed,
                                  title: Text(
                                    l10n.translate('blockAdultContent'),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    l10n.translate('blockAdultContentDesc'),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  value: rules.blockAdultContent,
                                  onChanged: (val) {
                                    rulesProv.toggleBlockAdultContent(val);
                                  },
                                ),
                                const SizedBox(height: 8),

                                // History Logging Toggle
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: Colors.teal,
                                  title: Text(
                                    l10n.translate('logBrowsingHistory'),
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    l10n.translate('logBrowsingHistoryDesc'),
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  value: rules.logWebHistory,
                                  onChanged: (val) {
                                    rulesProv.toggleLogWebHistory(val);
                                  },
                                ),
                                const SizedBox(height: 12),

                                // View Web Activity Log Button
                                OutlinedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => WebActivityLogScreen(child: widget.child),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    side: BorderSide(color: Colors.teal.shade400),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  icon: const Icon(Icons.history_rounded, color: Colors.teal, size: 18),
                                  label: Text(
                                    l10n.translate('webActivityLog'),
                                    style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Save Rules Button
                      ElevatedButton(
                        onPressed: rulesProv.isSaving
                            ? null
                            : () async {
                                final ok = await rulesProv.saveRules();
                                if (ok && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.translate('rulesSaved')),
                                      backgroundColor: AppColors.shieldGreen,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: rulesProv.isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                l10n.translate('saveRules'),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimeBox({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bedtimePurple,
                  ),
                ),
                const Icon(Icons.access_time_rounded, size: 18, color: AppColors.bedtimePurple),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
