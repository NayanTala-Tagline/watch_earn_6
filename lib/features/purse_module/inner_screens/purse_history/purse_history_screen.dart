import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_cash/extension/ext_context.dart';
import 'package:daily_cash/features/purse_module/provider/purse_provider.dart';
import 'package:daily_cash/routes/app_router.dart';
import 'package:daily_cash/utils/app_copy.dart';
import 'package:daily_cash/widgets/shared_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PurseHistoryScreen extends StatelessWidget {
  const PurseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PurseProvider>();
    final themeColors = context.themeColors;

    return Scaffold(
      backgroundColor: themeColors.backgroundColor,
      appBar: SharedAppBar(title: rootNavKey.currentContext!.l10n.withdrawHistory),
      body: StreamBuilder<QuerySnapshot>(
        stream: provider.getWithdrawStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
            );
          }
          if (snapshot.hasError) {
            return _buildEmptyState(
              icon: Icons.error_outline_rounded,
              title: rootNavKey.currentContext!.l10n.somethingWentWrong,
              subtitle: rootNavKey.currentContext!.l10n.pleaseTryAgainLater,
              iconColor: const Color(0xFFE05252),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return _buildEmptyState(
              icon: Icons.account_balance_wallet_outlined,
              title: rootNavKey.currentContext!.l10n.noWithdrawalsYet,
              subtitle: rootNavKey.currentContext!.l10n.yourWithdrawRequestAppearHere,
              iconColor: const Color(0xFF6C63FF),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              return _CashoutCard(data: data, index: index);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: iconColor.withOpacity(0.2)),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _CashoutCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final int index;

  const _CashoutCard({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final amount    = data['amount'] ?? 0;
    final type      = data['withdraw_type'] ?? '';
    final subType   = data['withdraw_sub_type'] ?? '';
    final status    = (data['status'] ?? 'pending').toString().toLowerCase();
    final createdAt = data['created_at'];
    final reason    = data['reason'] as String?;

    DateTime? date;
    if (createdAt != null) {
      date = (createdAt as Timestamp).toDate();
    }

    final cfg = _StateConfig.from(status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF16161E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left highlight bar ─────────────────────────
                Container(width: 4, color: cfg.accentColor),

                // ── Card content ────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Amount + badge row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Amount
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '₹ ',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: _formatAmount(amount),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Status badge
                            _StateBadge(cfg: cfg),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Divider
                        Divider(
                          height: 1,
                          thickness: 0.5,
                          color: Colors.white.withOpacity(0.07),
                        ),

                        const SizedBox(height: 14),

                        // Meta rows
                        _MetaLine(
                          icon: Icons.account_balance_rounded,
                          label: rootNavKey.currentContext!.l10n.method,
                          value: type.isNotEmpty ? type : '—',
                        ),
                        const SizedBox(height: 10),
                        _MetaLine(
                          icon: Icons.receipt_long_rounded,
                          label: rootNavKey.currentContext!.l10n.type,
                          value: subType.isNotEmpty ? subType : '—',
                        ),
                        const SizedBox(height: 10),
                        _MetaLine(
                          icon: Icons.schedule_rounded,
                          label: rootNavKey.currentContext!.l10n.date,
                          value: date != null ? _formatDate(date) : '—',
                        ),

                        // Reason row (only for rejected)
                        if (status == AppCopy.isRejected && reason != null) ...[
                          const SizedBox(height: 10),
                          _MetaLine(
                            icon: Icons.info_outline_rounded,
                            label: rootNavKey.currentContext!.l10n.reason,
                            value: reason,
                            valueColor: const Color(0xFFE05252),
                          ),
                        ],

                        // Processing time row (approved)
                        if (status == AppCopy.isApproved) ...[
                          const SizedBox(height: 10),
                          _MetaLine(
                            icon: Icons.check_circle_outline_rounded,
                            label: rootNavKey.currentContext!.l10n.processed,
                            value: rootNavKey.currentContext!.l10n.twoBusinessDays,
                            valueColor: const Color(0xFF4CAF82),
                          ),
                        ],

                        // Pending note
                        if (status == AppCopy.isPending) ...[
                          const SizedBox(height: 10),
                          _MetaLine(
                            icon: Icons.hourglass_top_rounded,
                            label: rootNavKey.currentContext!.l10n.statusNote,
                            value: rootNavKey.currentContext!.l10n.underReview,
                            valueColor: const Color(0xFFE6A817),
                          ),
                        ],

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatAmount(dynamic amount) {
    final num val = (amount is num) ? amount : num.tryParse('$amount') ?? 0;
    if (val >= 100000) {
      return '${(val / 100000).toStringAsFixed(1)}L';
    } else if (val >= 1000) {
      final parts = val.toStringAsFixed(0).split('');
      final reversed = parts.reversed.toList();
      final result = <String>[];
      for (int i = 0; i < reversed.length; i++) {
        if (i > 0 && i % 3 == 0) result.add(',');
        result.add(reversed[i]);
      }
      return result.reversed.join();
    }
    return '$val';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour   = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final min    = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'pm' : 'am';
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$min $period';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  META ROW
// ─────────────────────────────────────────────────────────────────────────────

class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color?   valueColor;

  const _MetaLine({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.07)),
          ),
          child: Icon(icon, size: 13, color: Colors.white.withOpacity(0.45)),
        ),
        const SizedBox(width: 10),

        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 12.5,
          ),
        ),

        const SizedBox(width: 8),

        /// 🔥 FIX HERE
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: valueColor ?? Colors.white.withOpacity(0.88),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STATUS BADGE
// ─────────────────────────────────────────────────────────────────────────────

class _StateBadge extends StatelessWidget {
  final _StateConfig cfg;
  const _StateBadge({required this.cfg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: cfg.accentColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cfg.accentColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: cfg.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),

          Padding(padding: EdgeInsets.only(top: 4),
            child:  Text(
              cfg.label,
              style: TextStyle(
                color: cfg.accentColor,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.10,
              ),
            ),
          )

        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  STATUS CONFIG HELPER
// ─────────────────────────────────────────────────────────────────────────────

class _StateConfig {
  final Color  accentColor;
  final String label;

  const _StateConfig({required this.accentColor, required this.label});

  factory _StateConfig.from(String status) {
    switch (status) {
      case AppCopy.isApproved:
        return _StateConfig(
          accentColor: const Color(0xFF4CAF82),
          label: rootNavKey.currentContext!.l10n.approved,
        );
      case AppCopy.isCompleted:
        return _StateConfig(
          accentColor: const Color(0xFF4CAF82),
          label: rootNavKey.currentContext!.l10n.approved,
        );
      case AppCopy.isRejected:
        return _StateConfig(
          accentColor: Color(0xFFE05252),
          label: rootNavKey.currentContext!.l10n.rejected,
        );
      case AppCopy.isPending:
        return _StateConfig(
          accentColor: Color(0xFFE6A817),
          label: rootNavKey.currentContext!.l10n.pending,
        );
      default:
        return _StateConfig(
          accentColor: Color(0xFFE6A817),
          label: rootNavKey.currentContext!.l10n.pending,
        );
    }
  }
}