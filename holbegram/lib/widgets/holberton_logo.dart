import 'package:flutter/material.dart';

/// The Holberton School seahorse mascot. The asset is already red, so no
/// tint is applied unless [color] is explicitly provided.
class HolbertonLogo extends StatelessWidget {
  const HolbertonLogo({super.key, this.size = 40, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/holberton_logo.png',
      height: size,
      width: size,
    );
    if (color == null) return image;
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
      child: image,
    );
  }
}
