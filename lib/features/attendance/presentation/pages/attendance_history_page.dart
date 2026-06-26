import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../injection_container.dart';
import '../bloc/attendance_history_bloc.dart';
import '../widgets/attendance_history_item.dart';

/// Halaman riwayat absensi (diterima & ditolak) dengan filter.
class AttendanceHistoryPage extends StatelessWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<AttendanceHistoryBloc>()..add(const LoadAttendanceHistory()),
      child: const _AttendanceHistoryView(),
    );
  }
}

class _AttendanceHistoryView extends StatelessWidget {
  const _AttendanceHistoryView();

  void _reload(BuildContext context) =>
      context.read<AttendanceHistoryBloc>().add(const LoadAttendanceHistory());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: BlocBuilder<AttendanceHistoryBloc, AttendanceHistoryState>(
        builder: (context, state) {
          if (state is AttendanceHistoryLoading ||
              state is AttendanceHistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AttendanceHistoryError) {
            return ErrorStateView(
              message: state.message,
              onRetry: () => _reload(context),
            );
          }
          if (state is AttendanceHistoryLoaded) {
            return Column(
              children: [
                _FilterChips(
                  active: state.filter,
                  onChanged: (f) => context
                      .read<AttendanceHistoryBloc>()
                      .add(FilterChanged(f)),
                ),
                Expanded(
                  child: state.filtered.isEmpty
                      ? _emptyView(context, state.filter)
                      : RefreshIndicator(
                          onRefresh: () async => _reload(context),
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            itemCount: state.filtered.length,
                            itemBuilder: (context, index) =>
                                AttendanceHistoryItem(
                              attendance: state.filtered[index],
                            ),
                          ),
                        ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _emptyView(BuildContext context, AttendanceFilter filter) {
    // Empty karena filter vs benar-benar belum ada data.
    if (filter != AttendanceFilter.all) {
      return EmptyStateView(
        icon: Icons.filter_alt_off,
        iconColor: AppColors.primaryLight,
        title: 'Tidak ada data',
        message: 'Belum ada absensi untuk filter ini.',
      );
    }
    return EmptyStateView(
      icon: Icons.history_toggle_off,
      iconColor: AppColors.accent,
      iconBackground: const Color(0xFFE0F7F3),
      title: 'Belum ada riwayat',
      message: 'Lakukan absensi pertama Anda untuk melihat catatan di sini.',
    );
  }
}

class _FilterChips extends StatelessWidget {
  final AttendanceFilter active;
  final ValueChanged<AttendanceFilter> onChanged;

  const _FilterChips({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          _Chip(
            label: 'Semua',
            selected: active == AttendanceFilter.all,
            color: AppColors.primary,
            onTap: () => onChanged(AttendanceFilter.all),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Diterima',
            selected: active == AttendanceFilter.accepted,
            color: AppColors.success,
            onTap: () => onChanged(AttendanceFilter.accepted),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: 'Ditolak',
            selected: active == AttendanceFilter.rejected,
            color: AppColors.danger,
            onTap: () => onChanged(AttendanceFilter.rejected),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAll = color == AppColors.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: selected && isAll ? AppColors.brandGradient : null,
            color: selected
                ? (isAll ? null : color)
                : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? Colors.transparent : color.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}
