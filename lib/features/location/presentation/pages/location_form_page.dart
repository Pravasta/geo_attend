import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/location_entity.dart';
import '../bloc/location_bloc.dart';

/// Form tambah / edit lokasi dengan tombol geotagging.
class LocationFormPage extends StatelessWidget {
  /// Jika `null`, form dalam mode tambah; jika berisi, mode edit.
  final LocationEntity? location;

  const LocationFormPage({super.key, this.location});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocationBloc>(),
      child: _LocationFormView(location: location),
    );
  }
}

class _LocationFormView extends StatefulWidget {
  final LocationEntity? location;

  const _LocationFormView({this.location});

  @override
  State<_LocationFormView> createState() => _LocationFormViewState();
}

class _LocationFormViewState extends State<_LocationFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  double? _latitude;
  double? _longitude;
  String? _address;

  bool get _isEdit => widget.location != null;

  @override
  void initState() {
    super.initState();
    final loc = widget.location;
    _nameController = TextEditingController(text: loc?.name ?? '');
    _latitude = loc?.latitude;
    _longitude = loc?.longitude;
    _address = loc?.address;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _hasCoordinate => _latitude != null && _longitude != null;

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasCoordinate) {
      Fluttertoast.showToast(msg: 'Ambil koordinat lokasi terlebih dahulu.');
      return;
    }

    final entity = LocationEntity(
      id: widget.location?.id,
      name: _nameController.text.trim(),
      latitude: _latitude!,
      longitude: _longitude!,
      address: _address,
      radius: widget.location?.radius ?? 50,
    );

    final bloc = context.read<LocationBloc>();
    if (_isEdit) {
      bloc.add(UpdateLocationEvent(entity));
    } else {
      bloc.add(AddLocationEvent(entity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Lokasi' : 'Tambah Lokasi')),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is CoordinateCaptured) {
            setState(() {
              _latitude = state.captured.latitude;
              _longitude = state.captured.longitude;
              _address = state.captured.address;
            });
            Fluttertoast.showToast(msg: 'Koordinat berhasil diambil.');
          } else if (state is LocationOperationSuccess) {
            Fluttertoast.showToast(msg: state.message);
            Navigator.of(context).pop(true);
          } else if (state is LocationError) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
        builder: (context, state) {
          final isBusy = state is LocationOperationInProgress;
          return AbsorbPointer(
            absorbing: isBusy,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lokasi',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Nama lokasi wajib diisi.'
                              : null,
                    ),
                    const SizedBox(height: 16),
                    _CoordinateCard(
                      latitude: _latitude,
                      longitude: _longitude,
                      address: _address,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: isBusy
                          ? null
                          : () => context
                              .read<LocationBloc>()
                              .add(const CaptureCoordinate()),
                      icon: const Icon(Icons.my_location),
                      label: const Text('Ambil Koordinat (Geotagging)'),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: isBusy ? null : _onSave,
                      icon: isBusy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isEdit ? 'Simpan Perubahan' : 'Simpan'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CoordinateCard extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? address;

  const _CoordinateCard({this.latitude, this.longitude, this.address});

  @override
  Widget build(BuildContext context) {
    final hasCoordinate = latitude != null && longitude != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Koordinat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (!hasCoordinate)
              const Text('Belum ada koordinat. Tekan "Ambil Koordinat".')
            else ...[
              Text('Latitude: ${latitude!.toStringAsFixed(6)}'),
              Text('Longitude: ${longitude!.toStringAsFixed(6)}'),
              if (address != null && address!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Alamat: $address'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
