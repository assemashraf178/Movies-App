import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/cubit/states.dart';
import 'package:movies_app/models/movies_model.dart';
import 'package:movies_app/models/search_model.dart';
import 'package:movies_app/shared/network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  var searchController = TextEditingController();

  MoviesModel? moviesModel;
  void getMoviesInfo() {
    emit(GetMoviesDataLoadingState());
    DioHelper.getData(
      url: 'http://api.themoviedb.org/3/movie/upcoming',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
      },
    ).then((value) {
      moviesModel = MoviesModel.fromJson(value.data);
      emit(GetMoviesDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetMoviesDataErrorState());
    });
  }

  SearchModel? searchModel;
  void getSearchInfo({
    required String text,
  }) {
    emit(GetSearchDataLoadingState());
    DioHelper.getData(
      url: 'https://api.themoviedb.org/3/search/movie',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
        'query': text,
      },
    ).then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(GetSearchDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetSearchDataErrorState());
    });
  }
}
