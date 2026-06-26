import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';

enum AppButtonVariant { primary, secondary }

/// Tombol utama aplikasi sesuai design system.
///
/// - `primary`: latar gradien brand + bayangan.
/// - `secondary`: latar putih dengan garis tepi primary.
/// Mendukung state **disabled** (onPressed null) & **loading**.
class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expand;
  final AppButtonVariant variant;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expand = true,
    this.variant = AppButtonVariant.primary,
    this.height = 52,
  });

  const AppButton.secondary({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    this.expand = true,
    this.height = 52,
  }) : variant = AppButtonVariant.secondary;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AppButtonVariant.primary;
    final textColor = isPrimary
        ? Colors.white
        : (_enabled ? AppColors.primary : AppColors.textSecondary);

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation(textColor),
            ),
          )
        else if (icon != null)
          Icon(icon, size: 20, color: textColor),
        if (loading || icon != null) const SizedBox(width: 10),
        Text(
          loading ? 'Memproses…' : label,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _enabled ? onPressed : null,
        child: Ink(
          height: height,
          decoration: _decoration(isPrimary),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: content,
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(bool isPrimary) {
    final radius = BorderRadius.circular(14);
    if (isPrimary) {
      return BoxDecoration(
        gradient: _enabled ? AppColors.brandGradient : null,
        color: _enabled ? null : const Color(0xFFC9CCDA),
        borderRadius: radius,
        boxShadow: _enabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      );
    }
    return BoxDecoration(
      color: Colors.white,
      borderRadius: radius,
      border: Border.all(
        color: _enabled ? const Color(0xFFC9D2FF) : const Color(0xFFE3E6F0),
        width: 1.5,
      ),
    );
  }
}

/// Tombol ikon kotak (mis. aksi edit) — latar lembut primary.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? background;
  final double size;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.background,
    this.size = 48,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: background ?? const Color(0xFFEEF1FF),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: 22, color: color ?? AppColors.primary),
        ),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
