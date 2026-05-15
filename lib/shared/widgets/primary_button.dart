import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/app_colors.dart';
import 'package:vendor_app/core/theme/app_spacing.dart';
import 'package:vendor_app/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.fullWidth = true,
    this.isBusy = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool fullWidth;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final child = isBusy
        ? SizedBox(
            height: AppSpacing.iconMd,
            width: AppSpacing.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: AppSpacing.xxs,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? AppColors.primaryGreen : Colors.white,
              ),
            ),
          )
        : _ButtonContent(
            text: text,
            icon: icon,
            textStyle: AppTextStyles.button.copyWith(
              color: isOutlined ? (textColor ?? AppColors.primaryGreen) : (textColor ?? Colors.white),
            ),
          );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isBusy ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: backgroundColor ?? AppColors.primaryGreen,
                width: AppSpacing.borderThin,
              ),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: isBusy ? null : onPressed,
            style: backgroundColor == null
                ? null
                : ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: textColor ?? Colors.white,
                  ),
            child: child,
          );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: button,
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.text,
    required this.icon,
    required this.textStyle,
  });

  final String text;
  final Widget? icon;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(text, style: textStyle);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        icon!,
        const SizedBox(width: AppSpacing.sm),
        Text(text, style: textStyle),
      ],
    );
  }
}
