import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/captured_location.dart';
import '../../domain/entities/location_entity.dart';
import '../../domain/usecases/add_location.dart';
import '../../domain/usecases/capture_current_location.dart';
import '../../domain/usecases/delete_location.dart';
import '../../domain/usecases/get_locations.dart';
import '../../domain/usecases/update_location.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetLocations getLocations;
  final AddLocation addLocation;
  final UpdateLocation updateLocation;
  final DeleteLocation deleteLocation;
  final CaptureCurrentLocation captureCurrentLocation;

  LocationBloc({
    required this.getLocations,
    required this.addLocation,
    required this.updateLocation,
    required this.deleteLocation,
    required this.captureCurrentLocation,
  }) : super(const LocationInitial()) {
    on<LoadLocations>(_onLoadLocations);
    on<CaptureCoordinate>(_onCaptureCoordinate);
    on<AddLocationEvent>(_onAddLocation);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<DeleteLocationEvent>(_onDeleteLocation);
  }

  Future<void> _onLoadLocations(
    LoadLocations event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());
    final result = await getLocations(const NoParams());
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (locations) => emit(LocationLoaded(locations)),
    );
  }

  Future<void> _onCaptureCoordinate(
    CaptureCoordinate event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationOperationInProgress());
    final result = await captureCurrentLocation(const NoParams());
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (captured) => emit(CoordinateCaptured(captured)),
    );
  }

  Future<void> _onAddLocation(
    AddLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationOperationInProgress());
    final result = await addLocation(event.location);
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (_) => emit(const LocationOperationSuccess('Lokasi berhasil ditambahkan.')),
    );
  }

  Future<void> _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationOperationInProgress());
    final result = await updateLocation(event.location);
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (_) => emit(const LocationOperationSuccess('Lokasi berhasil diperbarui.')),
    );
  }

  Future<void> _onDeleteLocation(
    DeleteLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await deleteLocation(event.id);
    result.fold(
      (failure) => emit(LocationError(failure.message)),
      (_) => emit(const LocationOperationSuccess('Lokasi berhasil dihapus.')),
    );
  }
}
