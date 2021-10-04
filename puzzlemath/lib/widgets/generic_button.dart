import 'package:flutter/material.dart';
import 'package:puzzlemath/theme/theme.dart';

enum ButtonVariant {
  primary,
}

class Button extends StatelessWidget {
  final String text;
  final ButtonVariant variant;
  final VoidCallback? onPressed;

  Button(
    this.text, {
    required VoidCallback? this.onPressed,
    ButtonVariant this.variant: ButtonVariant.primary,
  });

  factory Button.Primary(
    String text, {
    required VoidCallback? onPressed,
  }) {
    return Button(text, onPressed: onPressed, variant: ButtonVariant.primary);
  }

  ButtonStyle _primaryButtonStyle(BuildContext context) {
    return ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return ColorPrimaryPressed;
      } else if (states.contains(MaterialState.hovered)) {
        return ColorPrimaryHover;
      }
      return ColorPrimary;
    }), textStyle: MaterialStateProperty.resolveWith((states) {
      return TextMediumM;
    }), padding: MaterialStateProperty.resolveWith((states) {
      return EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      onPressed: onPressed,
      style: _primaryButtonStyle(context),
    );
  }
}
