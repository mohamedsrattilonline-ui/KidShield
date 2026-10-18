import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../data/models/child_device_model.dart';
import '../../../../data/models/web_activity_model.dart';
import '../../../../providers/web_activity_provider.dart';

class WebActivityLogScreen extends StatefulWidget {
  final ChildDeviceModel child;

  const WebActivityLogScreen({super.key, required this.child});

  @override
  State<WebActivityLogScreen> createState() => _WebActivityLogScreenState();
}

class _WebActivityLogScreenState extends State<WebActivityLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WebActivityProvider>(context, listen: false)
          .init(widget.child.childId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final webProv = Provider.of<WebActivityProvider>(context);

    final totalVisited = webProv.activities.length;
    final totalBlocked = webProv.activities.where((a) => a.isBlocked).length;

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text('${widget.child.childName} - ${l10n.translate("webActivityLog")}'),
      ),
      body: SafeArea(
        child: webProv.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  webProv.init(widget.child.childId);
                },
                child: Column(
                  children: [
                    // Summary Header Card
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Total Visited
                          Column(
                            children: [
                              Text(
                                '$totalVisited',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.translate('logBrowsingHistory'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Container(height: 35, width: 1, color: Colors.grey.shade300),
                          // Total Blocked
                          Column(
                            children: [
                              Text(
                                '$totalBlocked',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.sosRed,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.translate('blockedStatus'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Activity List
                    Expanded(
                      child: webProv.activities.isEmpty
                          ? Center(
                              child: Text(
                                l10n.translate('noWebActivityYet'),
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: webProv.activities.length,
                              itemBuilder: (context, index) {
                                final item = webProv.activities[index];
                                return _WebActivityItemCard(item: item, l10n: l10n);
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _WebActivityItemCard extends StatelessWidget {
  final WebActivityModel item;
  final AppLocalizations l10n;

  const _WebActivityItemCard({required this.item, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final timeStr =
        '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Domain Icon Box
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: item.isBlocked
                    ? AppColors.sosLightRed
                    : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                item.isBlocked
                    ? Icons.block_rounded
                    : Icons.public_rounded,
                color: item.isBlocked ? AppColors.sosRed : AppColors.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.domain,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: item.isBlocked
                                ? AppColors.sosRed
                                : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Blocked / Allowed Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.isBlocked
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: item.isBlocked ? Colors.red : Colors.green,
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          item.isBlocked
                              ? l10n.translate('blockedStatus')
                              : l10n.translate('allowedStatus'),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: item.isBlocked
                                ? Colors.red.shade800
                                : Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.pageTitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Time
                      Text(
                        timeStr,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
