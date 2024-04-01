import 'package:bloc/bloc.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_event.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_state.dart';

class CategoriesBloc extends Bloc<ManageCategoryEvent, CategoriesState> {
  CategoriesBloc() : super(const CategoriesState()) {
    on<SelectCategoryEvent>(_onSelectCategory);
    on<UnselectCategoryEvent>(_onUnselectCategory);
  }

  void _onSelectCategory(
      SelectCategoryEvent event,
      Emitter<CategoriesState> emit,
      ) {
    emit(state.copyWith(category: event.category));
  }

  void _onUnselectCategory(
      UnselectCategoryEvent event,
      Emitter<CategoriesState> emit,
      ) {
    emit(state.copyWith(category: null));
  }
}
