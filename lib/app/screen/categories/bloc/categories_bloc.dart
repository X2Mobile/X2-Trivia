import 'package:bloc/bloc.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_event.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(const CategoriesState()) {
    on<CategorySelect>(_onSelectCategory);
    on<CategoryUnselect>(_onUnselectCategory);
  }

  void _onSelectCategory(
    CategorySelect event,
    Emitter<CategoriesState> emit,
  ) {
    emit(state.copyWith(category: event.category));
  }

  void _onUnselectCategory(
    CategoryUnselect event,
    Emitter<CategoriesState> emit,
  ) {
    emit(state.copyWith(category: null));
  }
}
