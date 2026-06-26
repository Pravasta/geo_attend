import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/attendance_entity.dart';

/// Kartu item riwayat absensi sesuai mockup.
class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceHistoryItem({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final accepted = attendance.isAccepted;
    final color = accepted ? AppColors.success : AppColors.danger;
    final bg = accepted ? AppColors.successBg : AppColors.dangerBg;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                accepted ? Icons.check_circle : Icons.cancel,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attendance.locationName,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (attendance.timestamp != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      DateFormatter.formatHistoryDateTime(attendance.timestamp!),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    '${attendance.distance.toStringAsFixed(0)} m dari titik',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: accepted ? AppColors.accent : AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(accepted: accepted, showIcon: false, compact: true),
          ],
        ),
      ),
    );
  }
}
