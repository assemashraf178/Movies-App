import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:movies_app/cubit/cubit.dart';
import 'package:movies_app/cubit/states.dart';
import 'package:movies_app/models/movies_model.dart';
import 'package:movies_app/modules/movie/movie_screen.dart';
import 'package:movies_app/shared/components/constants.dart';

class UpcommingScreen extends StatefulWidget {
  const UpcommingScreen({Key? key}) : super(key: key);

  @override
  State<UpcommingScreen> createState() => _UpcommingScreenState();
}

class _UpcommingScreenState extends State<UpcommingScreen> {
  int page = 1;
  @override
  Widget build(BuildContext context) {
    print(page);
    AppCubit.get(context).getUpcommingMoviesInfo(page: page);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {},
        builder: (BuildContext context, AppStates state) {
          return RefreshIndicator(
            onRefresh: () async {
              return await AppCubit.get(context)
                  .getUpcommingMoviesInfo(page: page);
            },
            child: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) =>
                  AppCubit.get(context).upcommingMoviesModel != null &&
                  state is! GetUpcommingMoviesDataLoadingState,
              widgetBuilder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height / 80.0),
                    child: Column(
                      children: [
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return buildMovieCard(
                                context: context,
                                results: AppCubit.get(context)
                                    .upcommingMoviesModel!
                                    .results[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                            height: MediaQuery.of(context).size.height / 50.0,
                          ),
                          itemCount: AppCubit.get(context)
                              .upcommingMoviesModel!
                              .results
                              .length,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 80.0,
                        ),
                        Row(
                          children: [
                            if (page <=
                                    AppCubit.get(context)
                                        .upcommingMoviesModel!
                                        .totalPages &&
                                page != 1)
                              FloatingActionButton(
                                onPressed: () {
                                  if (page <
                                      AppCubit.get(context)
                                          .upcommingMoviesModel!
                                          .totalPages) {
                                    setState(() {
                                      page -= 1;
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                ),
                                backgroundColor: const Color(0xff314250),
                              ),
                            const Spacer(),
                            CircleAvatar(
                              backgroundColor: const Color(0xff314250),
                              child: Text(
                                '$page',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                      color: Colors.grey[200],
                                    ),
                              ),
                            ),
                            const Spacer(),
                            if (page <
                                AppCubit.get(context)
                                    .upcommingMoviesModel!
                                    .totalPages)
                              FloatingActionButton(
                                onPressed: () {
                                  if (page <
                                      AppCubit.get(context)
                                          .upcommingMoviesModel!
                                          .totalPages) {
                                    setState(() {
                                      page += 1;
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_forward_ios,
                                ),
                                backgroundColor: const Color(0xff314250),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 80.0,
                        ),
                      ],
                    ),
                  ),
                );
              },
              fallbackBuilder: (BuildContext context) => Center(
                  child: CircularProgressIndicator(
                color: Colors.grey[300],
              )),
            ),
          );
        });
  }

  Widget buildMovieCard({
    required BuildContext context,
    required Results results,
  }) =>
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MovieScreen(
                movie: results,
              ),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 5.0,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Card(
            elevation: 5.0,
            semanticContainer: true,
            clipBehavior: Clip.antiAlias,
            color: const Color(0xb51c262f),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image(
                    image: NetworkImage(
                      '$imageLink${results.posterPath.toString()}',
                    ),
                    // height: MediaQuery.of(context).size.height / 5.0,
                  ),
                  height: MediaQuery.of(context).size.height / 5.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 50.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        results.title.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Colors.white,
                              height: 1.5,
                            ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50.0,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 50.0,
                          ),
                          Text(
                            results.voteAverage.toString(),
                            style:
                                Theme.of(context).textTheme.caption!.copyWith(
                                      color: Colors.grey[400],
                                      height: 1.5,
                                    ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50.0,
                      ),
                      Text(
                        'Language : ${results.originalLanguage.toString()}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 1.5,
                              color: Colors.grey[400],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
