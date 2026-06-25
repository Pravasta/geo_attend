import 'package:equatable/equatable.dart';

/// Status hasil verifikasi absensi.
enum AttendanceStatus { accepted, rejected }

/// Entity satu catatan absensi.
///
/// Menyimpan koordinat pengguna saat absen, jarak terhitung ke titik lokasi,
/// status hasil verifikasi, dan snapshot nama lokasi.
class AttendanceEntity extends Equatable {
  final int? id;

  /// `null` bila lokasi master sudah dihapus (riwayat tetap disimpan).
  final int? locationId;
  final String locationName;

  /// Koordinat pengguna saat melakukan absensi.
  final double latitude;
  final double longitude;

  /// Jarak (meter) pengguna ke titik lokasi saat absensi.
  final double distance;

  final AttendanceStatus status;
  final DateTime? timestamp;

  const AttendanceEntity({
    this.id,
    this.locationId,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.status,
    this.timestamp,
  });

  bool get isAccepted => status == AttendanceStatus.accepted;

  @override
  List<Object?> get props => [
        id,
        locationId,
        locationName,
        latitude,
        longitude,
        distance,
        status,
        timestamp,
      ];
}
