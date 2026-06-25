import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
          }
        },
        builder: (context, attendanceState) {
          final isSubmitting = attendanceState is AttendanceSubmitting;
          return BlocBuilder<LocationBloc, LocationState>(
            buildWhen: (p, c) =>
                c is LocationLoading || c is LocationLoaded || c is LocationError,
            builder: (context, locationState) {
              if (locationState is LocationLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (locationState is LocationError) {
                return Center(child: Text(locationState.message));
              }
              if (locationState is LocationLoaded) {
                if (locationState.locations.isEmpty) {
                  return const _NoLocationView();
                }
                return _buildForm(locationState.locations, isSubmitting);
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildForm(List<LocationEntity> locations, bool isSubmitting) {
    // Pastikan item terpilih masih valid terhadap daftar terkini.
    if (_selected != null &&
        !locations.any((l) => l.id == _selected!.id)) {
      _selected = null;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Pilih lokasi absensi:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<LocationEntity>(
            initialValue: _selected,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Lokasi',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
            items: locations
                .map(
                  (loc) => DropdownMenuItem(
                    value: loc,
                    child: Text(loc.name, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: isSubmitting
                ? null
                : (value) => setState(() => _selected = value),
          ),
          if (_selected != null) ...[
            const SizedBox(height: 12),
            _SelectedLocationInfo(location: _selected!),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: isSubmitting ? null : _submit,
            icon: isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.fingerprint),
            label: Text(isSubmitting ? 'Memproses...' : 'Absensi Sekarang'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedLocationInfo extends StatelessWidget {
  final LocationEntity location;

  const _SelectedLocationInfo({required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
      ),
    );
  }
}

class _NoLocationView extends StatelessWidget {
  const _NoLocationView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wrong_location, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada lokasi terdaftar.\n'
              'Tambahkan lokasi terlebih dahulu di menu Manajemen Lokasi.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
