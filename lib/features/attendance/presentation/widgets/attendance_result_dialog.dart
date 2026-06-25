import 'package:flutter/material.dart';

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
    final color = accepted ? Colors.green : Colors.red;
    final icon = accepted ? Icons.check_circle : Icons.cancel;
    final title = accepted ? 'Absensi Berhasil' : 'Absensi Ditolak';
    final distanceText = '${record.distance.toStringAsFixed(1)} m';

    return AlertDialog(
      icon: Icon(icon, color: color, size: 56),
      title: Text(title, textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            record.locationName,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            accepted
                ? 'Anda berada $distanceText dari titik lokasi '
                    '(dalam radius).'
                : 'Anda berada $distanceText dari titik lokasi '
                    '(di luar radius).',
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}
