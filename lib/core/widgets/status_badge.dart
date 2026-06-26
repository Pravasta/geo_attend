import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

/// Badge status absensi (pill) — accepted (hijau) / rejected (merah).
class StatusBadge extends StatelessWidget {
  final bool accepted;

  /// Tampilkan ikon di depan teks.
  final bool showIcon;

  /// Ukuran ringkas (untuk list item).
  final bool compact;

  const StatusBadge({
    super.key,
    required this.accepted,
    this.showIcon = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = accepted ? AppColors.success : AppColors.danger;
    final bg = accepted ? AppColors.successBg : AppColors.dangerBg;
    final label = accepted ? 'Diterima' : 'Ditolak';
    final icon = accepted ? Icons.check_circle : Icons.cancel;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 12,
        vertical: compact ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon && !compact) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
