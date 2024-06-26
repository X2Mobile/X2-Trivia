import 'package:flutter/material.dart';

import '../../../domain/models/category.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onPressed,
  });

  final Category category;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          color: isSelected ? Colors.grey.shade200 : Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(category.icon.path, width: 56, height: 56),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(category.name),
                        ),
                      ],
                    ),
                    Icon(isSelected ? Icons.radio_button_on : Icons.radio_button_off_rounded)
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ));
  }
}
