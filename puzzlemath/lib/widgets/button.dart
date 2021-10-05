import 'package:flutter/material.dart';
import 'package:puzzlemath/theme/theme.dart';

enum ButtonVariant {
  primary,
  light,
}

class Button extends StatelessWidget {
  final String? text;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final bool enabled;
  final IconData? icon;

  Button({
    String? this.text: null,
    IconData? this.icon: null,
    required VoidCallback? this.onPressed,
    bool this.enabled: true,
    ButtonVariant this.variant: ButtonVariant.primary,
  });

  factory Button.Primary({
    String? text: null,
    bool enabled: true,
    IconData? icon: null,
    required VoidCallback? onPressed,
  }) {
    return Button(
        text: text,
        onPressed: onPressed,
        icon: icon,
        enabled: enabled,
        variant: ButtonVariant.primary);
  }

  factory Button.Light({
    String? text: null,
    bool enabled: true,
    IconData? icon: null,
    required VoidCallback? onPressed,
  }) {
    return Button(
        text: text,
        onPressed: onPressed,
        icon: icon,
        enabled: enabled,
        variant: ButtonVariant.light);
  }

  bool _isIconOnly() {
    return text == null && icon != null;
  }

  MaterialStateProperty<EdgeInsetsGeometry?> _padding() {
    return MaterialStateProperty.resolveWith((states) {
      return _isIconOnly()
          ? EdgeInsets.all(12.0)
          : EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
    });
  }

  ButtonStyle _defaultStyle(BuildContext context) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.resolveWith((states) => Size.zero),
      textStyle: MaterialStateProperty.resolveWith((states) {
        return TextMediumM;
      }),
      shape:
          MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              )),
      padding: _padding(),
      elevation: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return 0;
        }
        return 2;
      }),
    );
  }

  ButtonStyle _primaryButtonStyle(BuildContext context) {
    return _defaultStyle(context).copyWith(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ColorNeutral30;
        } else if (states.contains(MaterialState.pressed)) {
          return ColorPrimaryPressed;
        } else if (states.contains(MaterialState.hovered)) {
          return ColorPrimaryHover;
        }
        return ColorPrimary;
      }),
      foregroundColor: MaterialStateProperty.resolveWith((states) {
        return ColorNeutral10;
      }),
    );
  }

  ButtonStyle _lightButtonStyle(BuildContext context) {
    return _defaultStyle(context).copyWith(
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ColorNeutral10.withAlpha(125);
        } else if (states.contains(MaterialState.pressed)) {
          return ColorNeutral30;
        } else if (states.contains(MaterialState.hovered)) {
          return ColorNeutral20;
        }
        return ColorNeutral10;
      }),
      foregroundColor: MaterialStateProperty.all(ColorPrimary),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (icon == null) {
      return Text(text ?? '');
    }
    final iconWidget = Icon(icon, size: 20.0);
    if (text == null) {
      return iconWidget;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        iconWidget,
        SizedBox(width: 8),
        Text(text!),
      ],
    );
  }

  ButtonStyle _buildStyle(BuildContext context) {
    switch (variant) {
      case ButtonVariant.light:
        return _lightButtonStyle(context);
      default:
        return _primaryButtonStyle(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: _buildChild(context),
      onPressed: enabled ? onPressed : null,
      style: _buildStyle(context),
    );
  }
}
