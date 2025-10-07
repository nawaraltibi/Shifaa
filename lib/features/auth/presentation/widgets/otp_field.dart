import 'package:flutter/material.dart';
import 'package:shifaa/features/auth/presentation/widgets/otp_field_item.dart';

class OtpField extends StatefulWidget {
  final List<TextEditingController> controllers;

  const OtpField({super.key, required this.controllers});

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
    _focusNodes = List.generate(widget.controllers.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.controllers.length,
          (index) => OtpFieldItem(
            controller: widget.controllers[index],
            focusNode: _focusNodes[index],
            nextFocusNode: index < _focusNodes.length - 1
                ? _focusNodes[index + 1]
                : null,
            previousFocusNode: index > 0
                ? _focusNodes[index - 1]
                : null,
          ),
        ),
      ),
    );
  }
}
