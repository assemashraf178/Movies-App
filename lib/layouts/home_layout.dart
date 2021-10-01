import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:movies_app/cubit/cubit.dart';
import 'package:movies_app/cubit/states.dart';
import 'package:movies_app/modules/search/search_screen.dart';
import 'package:movies_app/shared/components/components.dart';
import 'package:movies_app/shared/components/constants.dart';

class HomeLayout extends StatefulWidget {
  HomeLayout({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int page = 1;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppCubit.get(context).getNowPlayingMoviesInfo(page: 1);
    AppCubit.get(context).getTopRatedMoviesInfo(page: 1);
    AppCubit.get(context).getPopularMoviesInfo(page: 1);
    AppCubit.get(context).getUpcomingMoviesInfo(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    print(page);
    var size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Movies'),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                )
              ],
            ),
            body: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) =>
                  state is! GetUpcomingMoviesDataLoadingState &&
                  AppCubit.get(context).upcomingMoviesModel != null &&
                  AppCubit.get(context).topRatedMoviesModel != null &&
                  AppCubit.get(context).nowPlayingMoviesModel != null &&
                  AppCubit.get(context).popularMoviesModel != null,
              widgetBuilder: (BuildContext context) => SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(size.height / 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMovieKind(
                        context: context,
                        text: 'Top Rated',
                        size: size,
                        navigatorText: topRated,
                        results:
                            AppCubit.get(context).topRatedMoviesModel!.results,
                      ),
                      buildMovieKind(
                        context: context,
                        text: 'Now Playing',
                        size: size,
                        navigatorText: nowPlaying,
                        results: AppCubit.get(context)
                            .nowPlayingMoviesModel!
                            .results,
                      ),
                      buildMovieKind(
                        context: context,
                        text: 'Popular',
                        size: size,
                        navigatorText: popular,
                        results:
                            AppCubit.get(context).popularMoviesModel!.results,
                      ),
                      buildMovieKind(
                        context: context,
                        text: 'Upcoming',
                        size: size,
                        navigatorText: upComing,
                        results:
                            AppCubit.get(context).upcomingMoviesModel!.results,
                      ),
                    ],
                  ),
                ),
              ),
              fallbackBuilder: (BuildContext context) => Center(
                child: CircularProgressIndicator(
                  color: Colors.grey[300],
                ),
              ),
            ),
          );
        });
  }
}
