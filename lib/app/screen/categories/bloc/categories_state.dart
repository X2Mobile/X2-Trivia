import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/category.dart';

class CategoriesState extends Equatable {
  const CategoriesState({
    this.selectedCategory,
  });

  final Category? selectedCategory;

  CategoriesState copyWith({
    Category? category,
  }) =>
      CategoriesState(
        selectedCategory: category,
      );

  @override
  List<Object?> get props => [selectedCategory];
}
