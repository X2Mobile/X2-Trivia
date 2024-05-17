import 'package:bloc/bloc.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_event.dart';
import 'package:x2trivia/app/screen/categories/bloc/categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(const CategoriesState());
}
