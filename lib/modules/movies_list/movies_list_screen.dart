import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:movies_app/cubit/cubit.dart';
import 'package:movies_app/cubit/states.dart';
import 'package:movies_app/models/movies_model.dart';
import 'package:movies_app/shared/components/components.dart';
import 'package:movies_app/shared/components/constants.dart';

class MoviesListScreen extends StatefulWidget {
  MoviesListScreen({
    Key? key,
    required this.modelName,
  }) : super(key: key);
  String modelName;

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  int page = 1;
  late MoviesModel model;

  @override
  Widget build(BuildContext context) {
    var cubit = AppCubit.get(context);
    if (widget.modelName == upComing) {
      model = AppCubit.get(context).upcomingMoviesModel!;
    } else if (widget.modelName == popular) {
      model = AppCubit.get(context).popularMoviesModel!;
    } else if (widget.modelName == topRated) {
      model = AppCubit.get(context).topRatedMoviesModel!;
    } else if (widget.modelName == nowPlaying) {
      model = AppCubit.get(context).nowPlayingMoviesModel!;
    }
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.modelName.toString(),
            ),
          ),
          body: Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) =>
                model != null &&
                state is! GetPopularMoviesDataLoadingState &&
                state is! GetNowPlayingMoviesDataLoadingState &&
                state is! GetTopRatedMoviesDataLoadingState &&
                state is! GetUpcomingMoviesDataLoadingState,
            widgetBuilder: (BuildContext context) {
              return buildMoviesList(
                context: context,
                page: page,
                model: model,
                totalPages: model.totalPages,
                state: state,
                onNextPressed: () {
                  setState(() {
                    page++;
                    if (widget.modelName == upComing) {
                      AppCubit.get(context).getUpcomingMoviesInfo(page: page);
                    } else if (widget.modelName == popular) {
                      AppCubit.get(context).getPopularMoviesInfo(page: page);
                    } else if (widget.modelName == topRated) {
                      AppCubit.get(context).getTopRatedMoviesInfo(page: page);
                    } else if (widget.modelName == nowPlaying) {
                      AppCubit.get(context).getNowPlayingMoviesInfo(page: page);
                    }
                  });
                },
                onBackPressed: () {
                  setState(() {
                    page--;
                    if (widget.modelName == upComing) {
                      AppCubit.get(context).getUpcomingMoviesInfo(page: page);
                    } else if (widget.modelName == popular) {
                      AppCubit.get(context).getPopularMoviesInfo(page: page);
                    } else if (widget.modelName == topRated) {
                      AppCubit.get(context).getTopRatedMoviesInfo(page: page);
                    } else if (widget.modelName == nowPlaying) {
                      AppCubit.get(context).getNowPlayingMoviesInfo(page: page);
                    }
                  });
                },
              );
            },
            fallbackBuilder: (BuildContext context) => Center(
                child: CircularProgressIndicator(
              color: Colors.grey[300],
            )),
          ),
        );
      },
    );
  }
}
