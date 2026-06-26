import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../../location/domain/entities/location_entity.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../bloc/attendance_bloc.dart';
import '../widgets/attendance_result_dialog.dart';

/// Halaman absensi: pilih lokasi lalu lakukan absensi (verifikasi radius).
class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<LocationBloc>()..add(const LoadLocations()),
        ),
        BlocProvider(create: (_) => sl<AttendanceBloc>()),
      ],
      child: const _AttendanceView(),
    );
  }
}

class _AttendanceView extends StatefulWidget {
  const _AttendanceView();

  @override
  State<_AttendanceView> createState() => _AttendanceViewState();
}

class _AttendanceViewState extends State<_AttendanceView> {
  LocationEntity? _selected;
  bool? _gpsEnabled;

  @override
  void initState() {
    super.initState();
    _checkGps();
  }

  Future<void> _checkGps() async {
    final enabled = await sl<LocationService>().isLocationServiceEnabled();
    if (mounted) setState(() => _gpsEnabled = enabled);
  }

  void _submit() {
    if (_selected == null) {
      Fluttertoast.showToast(msg: 'Pilih lokasi terlebih dahulu.');
      return;
    }
    context.read<AttendanceBloc>().add(SubmitAttendanceEvent(_selected!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absensi')),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceAccepted) {
            AttendanceResultDialog.show(context, state.record);
          } else if (state is AttendanceRejected) {
            AttendanceResultDialog.show(context, state.record);
          } else if (state is AttendanceFailureState) {
            Fluttertoast.showToast(msg: state.message);
            _checkGps();
          }
        },
        builder: (context, attendanceState) {
          final isSubmitting = attendanceState is AttendanceSubmitting;
          return BlocBuilder<LocationBloc, LocationState>(
            buildWhen: (p, c) =>
                c is LocationLoading ||
                c is LocationLoaded ||
                c is LocationError,
            builder: (context, locationState) {
              if (locationState is LocationLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (locationState is LocationError) {
                return ErrorStateView(
                  message: locationState.message,
                  onRetry: () =>
                      context.read<LocationBloc>().add(const LoadLocations()),
                );
              }
              if (locationState is LocationLoaded) {
                if (locationState.locations.isEmpty) {
                  return _NoLocationView(
                    onAdd: () => Navigator.of(context).pop(),
                  );
                }
                return _buildContent(locationState.locations, isSubmitting);
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(List<LocationEntity> locations, bool isSubmitting) {
    // Pastikan item terpilih masih valid terhadap daftar terkini.
    if (_selected != null && !locations.any((l) => l.id == _selected!.id)) {
      _selected = null;
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Pilih lokasi',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                _LocationDropdown(
                  locations: locations,
                  selected: _selected,
                  enabled: !isSubmitting,
                  onChanged: (value) => setState(() => _selected = value),
                ),
                if (_selected != null) ...[
                  const SizedBox(height: 16),
                  _DetailCard(location: _selected!, gpsEnabled: _gpsEnabled),
                  const SizedBox(height: 16),
                  const _PositionPreview(),
                ],
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: AppButton(
              label: 'Absensi Sekarang',
              icon: Icons.fingerprint,
              loading: isSubmitting,
              onPressed: isSubmitting ? null : _submit,
              height: 56,
            ),
          ),
        ),
      ],
    );
  }
}

class _LocationDropdown extends StatelessWidget {
  final List<LocationEntity> locations;
  final LocationEntity? selected;
  final bool enabled;
  final ValueChanged<LocationEntity?> onChanged;

  const _LocationDropdown({
    required this.locations,
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<LocationEntity>(
      initialValue: selected,
      isExpanded: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.place, color: AppColors.primary),
      ),
      hint: const Text('Pilih lokasi absensi'),
      items: locations
          .map(
            (loc) => DropdownMenuItem(
              value: loc,
              child: Text(loc.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _DetailCard extends StatelessWidget {
  final LocationEntity location;
  final bool? gpsEnabled;

  const _DetailCard({required this.location, required this.gpsEnabled});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                'Detail Lokasi',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DetailRow(
            label: 'Koordinat',
            value: '${location.latitude.toStringAsFixed(5)}, '
                '${location.longitude.toStringAsFixed(5)}',
          ),
          const Divider(height: 20),
          _DetailRow(
            label: 'Radius',
            value: '${location.radius.toStringAsFixed(0)} m',
          ),
          const Divider(height: 20),
          _DetailRow(
            label: 'Status GPS',
            valueWidget: _GpsStatus(enabled: gpsEnabled),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;

  const _DetailRow({required this.label, this.value, this.valueWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        valueWidget ??
            Text(
              value!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
      ],
    );
  }
}

class _GpsStatus extends StatelessWidget {
  final bool? enabled;

  const _GpsStatus({required this.enabled});

  @override
  Widget build(BuildContext context) {
    if (enabled == null) {
      return Text(
        'Memeriksa…',
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      );
    }
    final on = enabled!;
    return Text(
      on ? 'Aktif' : 'Tidak aktif',
      style: GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: on ? AppColors.success : AppColors.danger,
      ),
    );
  }
}

class _PositionPreview extends StatelessWidget {
  const _PositionPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFEDEFF7), Color(0xFFF4F5FB)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_pin_circle,
              size: 36, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            'Posisi Anda akan diverifikasi saat absensi',
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoLocationView extends StatelessWidget {
  final VoidCallback onAdd;

  const _NoLocationView({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      icon: Icons.wrong_location,
      iconColor: AppColors.primaryLight,
      title: 'Belum ada lokasi',
      message: 'Tambahkan lokasi terlebih dahulu di menu Lokasi sebelum '
          'melakukan absensi.',
      actionLabel: 'Ke Menu Lokasi',
      actionIcon: Icons.place,
      onAction: onAdd,
    );
  }
}
