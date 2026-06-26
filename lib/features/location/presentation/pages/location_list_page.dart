import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
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

  Future<void> _openForm(
    BuildContext context, {
    LocationEntity? location,
  }) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => LocationFormPage(location: location)),
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
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
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
      appBar: AppBar(title: const Text('Lokasi')),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationOperationSuccess) {
            Fluttertoast.showToast(msg: state.message);
            _reload(context);
          } else if (state is LocationError) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        buildWhen: (previous, current) =>
            current is LocationLoading ||
            current is LocationLoaded ||
            current is LocationError,
        builder: (context, state) {
          if (state is LocationLoading) {
            return const _LocationSkeleton();
          }
          if (state is LocationError) {
            return ErrorStateView(
              message: state.message,
              onRetry: () => _reload(context),
            );
          }
          if (state is LocationLoaded) {
            if (state.locations.isEmpty) {
              return EmptyStateView(
                icon: Icons.location_off,
                iconColor: AppColors.primaryLight,
                title: 'Belum ada lokasi',
                message:
                    'Tambahkan titik lokasi terlebih dahulu untuk mulai '
                    'melakukan absensi.',
                actionLabel: 'Tambah Lokasi',
                actionIcon: Icons.add_location_alt,
                onAction: () => _openForm(context),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.locations.length,
              physics: const BouncingScrollPhysics(),
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
        builder: (context) => _GradientFab(onPressed: () => _openForm(context)),
      ),
    );
  }
}

/// FAB gradien brand.
class _GradientFab extends StatelessWidget {
  final VoidCallback onPressed;

  const _GradientFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onPressed,
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

/// Skeleton loading untuk daftar lokasi (3 kartu).
class _LocationSkeleton extends StatelessWidget {
  const _LocationSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: 3,
      itemBuilder: (context, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonBox(width: 40, height: 40, radius: 12),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SkeletonBox(width: 130, height: 13, radius: 6),
                        SizedBox(height: 8),
                        SkeletonBox(width: 200, height: 10, radius: 6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  SkeletonBox(width: 130, height: 22, radius: 8),
                  SizedBox(width: 8),
                  SkeletonBox(width: 55, height: 22, radius: 8),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  SkeletonBox(width: 68, height: 34, radius: 10),
                  SizedBox(width: 8),
                  SkeletonBox(width: 72, height: 34, radius: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
