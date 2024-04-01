import 'package:equatable/equatable.dart';
import 'package:x2trivia/domain/models/category.dart';

sealed class ManageCategoryEvent extends Equatable {
  const ManageCategoryEvent();

  @override
  List<Object> get props => [];
}

final class SelectCategoryEvent extends ManageCategoryEvent {
  const SelectCategoryEvent({
    required this.category,
  });

  final Category category;

  @override
  List<Object> get props => [category];
}

final class UnselectCategoryEvent extends ManageCategoryEvent {
  const UnselectCategoryEvent();

  @override
  List<Object> get props => [];
}
