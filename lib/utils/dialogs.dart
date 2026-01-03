import 'package:flutter/material.dart';

/// Shows a small centered success dialog for [durationMs] milliseconds and
/// then dismisses itself.
Future<void> showSuccessDialog(BuildContext context, String message,
    {int durationMs = 1000}) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (c) => Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.symmetric(horizontal: 24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 12),
              Flexible(
                  child: Text(message, style: const TextStyle(fontSize: 16))),
            ],
          ),
        ),
      ),
    ),
  );

  await Future.delayed(Duration(milliseconds: durationMs));

  if (Navigator.canPop(context)) Navigator.pop(context);
}
