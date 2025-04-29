import 'package:flutter/material.dart';
import 'package:roboroots/screens/home/profile/profile_screen.dart';

class CustomHeader extends StatelessWidget {
  final VoidCallback? onBrandIconTap;
  final VoidCallback? onAvatarTap;

  const CustomHeader({
    Key? key,
    this.onBrandIconTap,
    this.onAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left area: Grid icon with "Roboroots" text.
            GestureDetector(
              onTap: onBrandIconTap,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.grid_view_rounded,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Roboroots",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            // Right avatar.
            GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage("lib/assets/images/avatar.png"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
