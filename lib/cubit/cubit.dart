import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/cubit/states.dart';
import 'package:movies_app/models/genres_model.dart';
import 'package:movies_app/models/movies_model.dart';
import 'package:movies_app/models/search_model.dart';
import 'package:movies_app/shared/network/remote/dio_helper.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  var searchController = TextEditingController();

  int currentIndex = 0;

  void setState() {
    emit(SetState());
  }

  List<SalomonBottomBarItem> items = [
    SalomonBottomBarItem(
      icon: const Icon(
        Icons.play_arrow,
      ),
      title: const Text('Now Playing'),
      // backgroundColor: Color(0xff1C262F),
    ),
    SalomonBottomBarItem(
      icon: const Icon(
        Icons.favorite,
      ),
      title: const Text('Popular'),
      // backgroundColor: Color(0xff1C262F),
    ),
    SalomonBottomBarItem(
      icon: const Icon(
        Icons.star,
      ),
      title: const Text('Top Rated'),
      // backgroundColor: Color(0xff1C262F),
    ),
    SalomonBottomBarItem(
      icon: const Icon(
        Icons.upcoming,
      ),
      title: const Text('Upcoming'),

      // backgroundColor: Color(0xff1C262F),
    ),
  ];

  List<String> titles = [
    'Now Playing',
    'Popular',
    'Top Rated',
    'Upcoming',
  ];

  void changeBottomNavBarIndex(int index) {
    currentIndex = index;
    print(currentIndex);
    emit(ChangeBottomNavBarIndexState());
  }

  GenresModel? genresModel;
  Future<void> getGenresMoviesInfo() async {
    emit(GetGenresMoviesDataLoadingState());
    DioHelper.getData(
      url: 'http://api.themoviedb.org/3/genre/movie/list',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
      },
    ).then((value) {
      genresModel = GenresModel.fromJson(value.data);
      print(genresModel!.genres);
      print(genresModel!.genres[0].name.toString());
      emit(GetGenresMoviesDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetGenresMoviesDataErrorState());
    });
  }

  MoviesModel? upcomingMoviesModel;
  Future<void> getUpcomingMoviesInfo({
    required int page,
  }) async {
    emit(GetUpcomingMoviesDataLoadingState());
    DioHelper.getData(
      url: 'http://api.themoviedb.org/3/movie/upcoming',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
        'page': page,
      },
    ).then((value) {
      upcomingMoviesModel = MoviesModel.fromJson(value.data);
      print(upcomingMoviesModel!.results[0].title);
      emit(GetUpcomingMoviesDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetUpcomingMoviesDataErrorState());
    });
  }

  MoviesModel? popularMoviesModel;
  Future<void> getPopularMoviesInfo({
    required int page,
  }) async {
    emit(GetPopularMoviesDataLoadingState());
    DioHelper.getData(
      url: 'http://api.themoviedb.org/3/movie/popular',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
        'page': page,
      },
    ).then((value) {
      popularMoviesModel = MoviesModel.fromJson(value.data);
      print(popularMoviesModel!.results[0].title);
      emit(GetPopularMoviesDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetPopularMoviesDataErrorState());
    });
  }

  MoviesModel? topRatedMoviesModel;
  Future<void> getTopRatedMoviesInfo({
    required int page,
  }) async {
    emit(GetTopRatedMoviesDataLoadingState());
    DioHelper.getData(
      url: 'http://api.themoviedb.org/3/movie/top_rated',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
        'page': page,
      },
    ).then((value) {
      topRatedMoviesModel = MoviesModel.fromJson(value.data);
      print(topRatedMoviesModel!.results[0].title);
      emit(GetTopRatedMoviesDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetTopRatedMoviesDataErrorState());
    });
  }

  MoviesModel? nowPlayingMoviesModel;
  Future<void> getNowPlayingMoviesInfo({
    required dynamic page,
  }) async {
    emit(GetNowPlayingMoviesDataLoadingState());
    DioHelper.getData(
      url: 'http://api.themoviedb.org/3/movie/now_playing',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
        'page': page,
      },
    ).then((value) {
      nowPlayingMoviesModel = MoviesModel.fromJson(value.data);
      print(nowPlayingMoviesModel!.results[0].title);
      emit(GetNowPlayingMoviesDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetNowPlayingMoviesDataErrorState());
    });
  }

  SearchModel? searchModel;
  void getSearchInfo({
    required String text,
    required int page,
  }) {
    emit(GetSearchDataLoadingState());
    DioHelper.getData(
      url: 'https://api.themoviedb.org/3/search/movie',
      query: {
        'api_key': '5efb56a35aab9a710a1f08812daa0a81',
        'query': text,
        'page': page,
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
