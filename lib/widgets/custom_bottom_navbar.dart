import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double iconSize = 32.0; // Increased icon size

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        children: [
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.home),
              iconSize: iconSize,
              color: currentIndex == 0 ? Colors.blue : Colors.grey,
              onPressed: () => onTabSelected(0),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.menu_book_outlined),
              iconSize: iconSize,
              color: currentIndex == 1 ? Colors.blue : Colors.grey,
              onPressed: () => onTabSelected(1),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.smart_toy),
              iconSize: iconSize,
              color: currentIndex == 2 ? Colors.blue : Colors.grey,
              onPressed: () => onTabSelected(2),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.search),
              iconSize: iconSize,
              color: currentIndex == 3 ? Colors.blue : Colors.grey,
              onPressed: () => onTabSelected(3),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.menu),
              iconSize: iconSize,
              color: currentIndex == 4 ? Colors.blue : Colors.grey,
              onPressed: () => onTabSelected(4),
            ),
          ),
        ],
      ),
    );
  }
}
