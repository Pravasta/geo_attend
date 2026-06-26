import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/location_entity.dart';
import '../bloc/location_bloc.dart';
import 'map_picker_page.dart';

/// Form tambah / edit lokasi dengan geotagging GPS & map picker.
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
  bool get _hasCoordinate => _latitude != null && _longitude != null;

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

  Future<void> _pickOnMap() async {
    final result = await Navigator.of(context).push<MapPickerResult>(
      MaterialPageRoute(
        builder: (_) => MapPickerPage(
          initialLatitude: _latitude,
          initialLongitude: _longitude,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _address = result.address;
      });
      Fluttertoast.showToast(msg: 'Titik lokasi dipilih dari peta.');
    }
  }

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
          return Column(
            children: [
              Expanded(
                child: AbsorbPointer(
                  absorbing: isBusy,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _NameField(controller: _nameController),
                          const SizedBox(height: 18),
                          _CoordinateCard(
                            latitude: _latitude,
                            longitude: _longitude,
                            address: _address,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Ambil Titik Lokasi',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            label: 'Ambil Koordinat (GPS)',
                            icon: Icons.gps_fixed,
                            loading: isBusy,
                            onPressed: isBusy
                                ? null
                                : () => context
                                    .read<LocationBloc>()
                                    .add(const CaptureCoordinate()),
                          ),
                          const SizedBox(height: 10),
                          AppButton.secondary(
                            label: 'Pilih di Peta',
                            icon: Icons.map,
                            onPressed: isBusy ? null : _pickOnMap,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _BottomBar(
                child: AppButton(
                  label: _isEdit ? 'Simpan Perubahan' : 'Simpan Lokasi',
                  loading: isBusy,
                  onPressed: isBusy ? null : _onSave,
                  height: 56,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;

  const _NameField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Nama Lokasi ',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            children: const [
              TextSpan(text: '*', style: TextStyle(color: AppColors.danger)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'mis. Kantor Pusat',
            prefixIcon: Icon(Icons.edit_location_alt, color: AppColors.primary),
          ),
          validator: (value) => (value == null || value.trim().isEmpty)
              ? 'Nama lokasi wajib diisi.'
              : null,
        ),
      ],
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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.my_location, size: 18, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                'Koordinat Terpilih',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!hasCoordinate)
            Text(
              'Belum ada koordinat. Ambil via GPS atau pilih di peta.',
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: AppColors.textSecondary,
              ),
            )
          else ...[
            _Row(label: 'Latitude', value: latitude!.toStringAsFixed(6)),
            const SizedBox(height: 6),
            _Row(label: 'Longitude', value: longitude!.toStringAsFixed(6)),
            if (address != null && address!.trim().isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1),
              ),
              _Row(label: 'Alamat', value: address!),
            ],
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Bar bawah dengan tombol aksi (fade gradient halus dari latar).
class _BottomBar extends StatelessWidget {
  final Widget child;

  const _BottomBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(color: AppColors.background),
      child: SafeArea(top: false, child: child),
    );
  }
}
