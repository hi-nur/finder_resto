import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: currentIndex == 0 ? Colors.blue : Colors.grey,
            ),
            onPressed: () => onTap(0),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: currentIndex == 1 ? Colors.red : Colors.grey,
            ),
            onPressed: () => onTap(1),
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: currentIndex == 2 ? Colors.blue : Colors.grey,
            ),
            onPressed: () => onTap(2),
          ),
        ],
      ),
    );
  }
}
