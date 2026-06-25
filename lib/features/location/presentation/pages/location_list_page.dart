import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/location_entity.dart';
import '../bloc/location_bloc.dart';
import '../widgets/location_list_item.dart';
import 'location_form_page.dart';

/// Halaman daftar lokasi (master data).
class LocationListPage extends StatelessWidget {
  const LocationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocationBloc>()..add(const LoadLocations()),
      child: const _LocationListView(),
    );
  }
}

class _LocationListView extends StatelessWidget {
  const _LocationListView();

  void _reload(BuildContext context) =>
      context.read<LocationBloc>().add(const LoadLocations());

  Future<void> _openForm(BuildContext context, {LocationEntity? location}) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LocationFormPage(location: location),
      ),
    );
    if (saved == true && context.mounted) {
      _reload(context);
    }
  }

  Future<void> _confirmDelete(BuildContext context, LocationEntity loc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Lokasi'),
        content: Text('Yakin ingin menghapus "${loc.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<LocationBloc>().add(DeleteLocationEvent(loc.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Lokasi')),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationOperationSuccess) {
            Fluttertoast.showToast(msg: state.message);
            _reload(context);
          } else if (state is LocationError) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        // Hanya bangun ulang untuk state yang berkaitan dengan tampilan daftar.
        buildWhen: (previous, current) =>
            current is LocationLoading ||
            current is LocationLoaded ||
            current is LocationError,
        builder: (context, state) {
          if (state is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LocationError) {
            return _ErrorView(
              message: state.message,
              onRetry: () => _reload(context),
            );
          }
          if (state is LocationLoaded) {
            if (state.locations.isEmpty) {
              return const _EmptyView();
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.locations.length,
              itemBuilder: (context, index) {
                final loc = state.locations[index];
                return LocationListItem(
                  location: loc,
                  onEdit: () => _openForm(context, location: loc),
                  onDelete: () => _confirmDelete(context, loc),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () => _openForm(context),
          icon: const Icon(Icons.add_location_alt),
          label: const Text('Tambah'),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada lokasi.\nTekan tombol "Tambah" untuk menambahkan.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
