import 'package:flutter/material.dart';

/// The "X" mark of the NEXA logo.
///
/// Sourced from [asset/image/Nexa_Mark.png], the standalone transparent mark
/// cropped out of the full wordmark. The launcher icon and native splash
/// screens are generated from the same file, so the brand stays in sync
/// everywhere.
class NexaMark extends StatelessWidget {
  final double size;

  const NexaMark({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset('asset/image/Nexa_Mark.png', fit: BoxFit.contain),
    );
  }
}
