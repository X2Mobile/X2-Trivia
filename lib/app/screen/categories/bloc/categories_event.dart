import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/category.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

final class CategorySelect extends CategoriesEvent {
  const CategorySelect({
    required this.category,
  });

  final Category category;

  @override
  List<Object> get props => [category];
}

final class CategoryUnselect extends CategoriesEvent {
  const CategoryUnselect();

  @override
  List<Object> get props => [];
}
