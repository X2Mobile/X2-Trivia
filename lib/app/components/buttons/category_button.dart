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
    return isSelected
        ? OutlinedButton(
            onPressed: onPressed,
            child: Text(category.name),
          )
        : TextButton(
            onPressed: onPressed,
            child: Text(category.name)
          );
  }
}
