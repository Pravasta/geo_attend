import 'package:flutter/material.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/attendance_entity.dart';

/// Kartu item riwayat absensi.
class AttendanceHistoryItem extends StatelessWidget {
  final AttendanceEntity attendance;

  const AttendanceHistoryItem({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final accepted = attendance.isAccepted;
    final color = accepted ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(
            accepted ? Icons.check_circle : Icons.cancel,
            color: color,
          ),
        ),
        title: Text(
          attendance.locationName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (attendance.timestamp != null)
              Text(DateFormatter.formatDateTime(attendance.timestamp!)),
            Text(
              'Jarak: ${attendance.distance.toStringAsFixed(1)} m',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: _StatusBadge(accepted: accepted, color: color),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool accepted;
  final Color color;

  const _StatusBadge({required this.accepted, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        accepted ? 'Diterima' : 'Ditolak',
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
