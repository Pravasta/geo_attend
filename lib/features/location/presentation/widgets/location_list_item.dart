import 'package:flutter/material.dart';

import '../../domain/entities/location_entity.dart';

/// Kartu item lokasi pada daftar.
class LocationListItem extends StatelessWidget {
  final LocationEntity location;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LocationListItem({
    super.key,
    required this.location,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.location_on)),
        title: Text(
          location.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (location.address != null && location.address!.isNotEmpty)
              Text(location.address!),
            Text(
              '${location.latitude.toStringAsFixed(6)}, '
              '${location.longitude.toStringAsFixed(6)}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Radius: ${location.radius.toStringAsFixed(0)} m',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.indigo),
              tooltip: 'Edit',
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Hapus',
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
