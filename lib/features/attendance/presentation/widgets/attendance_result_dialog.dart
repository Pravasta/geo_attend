import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/entities/attendance_entity.dart';

/// Dialog hasil absensi (diterima / ditolak) beserta info jarak.
class AttendanceResultDialog extends StatelessWidget {
  final AttendanceEntity record;

  const AttendanceResultDialog({super.key, required this.record});

  static Future<void> show(BuildContext context, AttendanceEntity record) {
    return showDialog<void>(
      context: context,
      builder: (_) => AttendanceResultDialog(record: record),
    );
  }

  @override
  Widget build(BuildContext context) {
    final accepted = record.isAccepted;
    final color = accepted ? AppColors.success : AppColors.danger;
    final bg = accepted ? AppColors.successBg : AppColors.dangerBg;
    final distance = '${record.distance.toStringAsFixed(0)} m dari titik lokasi';
    final time = record.timestamp != null
        ? DateFormatter.formatTime(record.timestamp!)
        : null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulseIcon(
              color: color,
              background: bg,
              icon: accepted ? Icons.check_circle : Icons.cancel,
              animate: accepted,
            ),
            const SizedBox(height: 18),
            Text(
              accepted ? 'Absensi Berhasil' : 'Absensi Ditolak',
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(
                    text: accepted
                        ? 'Kehadiran Anda di '
                        : 'Anda berada di luar radius lokasi ',
                  ),
                  TextSpan(
                    text: record.locationName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(text: accepted ? ' tercatat.' : '.'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(accepted ? Icons.near_me : Icons.wrong_location,
                      color: color, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          distance,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${accepted ? 'Dalam' : 'Di luar'} radius 50 m'
                          '${time != null ? ' · $time' : ''}',
                          style: GoogleFonts.poppins(
                            fontSize: 11.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            accepted
                ? AppButton(
                    label: 'Selesai',
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : AppButton.secondary(
                    label: 'Tutup',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
          ],
        ),
      ),
    );
  }
}

/// Ikon hasil dengan denyut (pulse) untuk status diterima.
class _PulseIcon extends StatefulWidget {
  final Color color;
  final Color background;
  final IconData icon;
  final bool animate;

  const _PulseIcon({
    required this.color,
    required this.background,
    required this.icon,
    required this.animate,
  });

  @override
  State<_PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<_PulseIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.animate) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      )..repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_controller != null)
            AnimatedBuilder(
              animation: _controller!,
              builder: (context, _) {
                final t = _controller!.value;
                return Container(
                  width: 92 * (0.9 + t * 0.35),
                  height: 92 * (0.9 + t * 0.35),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: (1 - t) * 0.18),
                  ),
                );
              },
            ),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.background,
            ),
            child: Icon(widget.icon, size: 54, color: widget.color),
          ),
        ],
      ),
    );
  }
}
