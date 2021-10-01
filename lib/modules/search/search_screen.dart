import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:movies_app/cubit/cubit.dart';
import 'package:movies_app/cubit/states.dart';
import 'package:movies_app/models/search_model.dart';
import 'package:movies_app/modules/movie/movie_screen.dart';
import 'package:movies_app/shared/components/components.dart';
import 'package:movies_app/shared/components/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var formKey = GlobalKey<FormState>();
  int page = 1;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Search'),
          ),
          body: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 50.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height / 60.0),
                      child: defaultTextFormField(
                        hint: 'search',
                        prefixIcon: Icons.search,
                        context: context,
                        type: TextInputType.text,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'search must not be empty';
                          }
                          return null;
                        },
                        controller: AppCubit.get(context).searchController,
                        onChange: (String value) {
                          if (value != '') {
                            page = 1;
                            AppCubit.get(context).getSearchInfo(
                              text: value,
                              page: page,
                            );
                          }
                        },
                        onSubmit: (String value) {
                          if (value != '') {
                            page = 1;
                            AppCubit.get(context).getSearchInfo(
                              text: value,
                              page: page,
                            );
                          }
                        },
                      ),
                    ),
                    if (AppCubit.get(context).searchModel != null)
                      Conditional.single(
                        context: context,
                        conditionBuilder: (BuildContext context) =>
                            AppCubit.get(context).searchModel != null &&
                            state is! GetSearchDataLoadingState,
                        widgetBuilder: (BuildContext context) {
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.height / 80.0),
                            itemBuilder: (BuildContext context, int index) {
                              return buildMovieCard(
                                  context: context,
                                  results: AppCubit.get(context)
                                      .searchModel!
                                      .results[index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(),
                            itemCount: AppCubit.get(context)
                                .searchModel!
                                .results
                                .length,
                          );
                        },
                        fallbackBuilder: (BuildContext context) => Center(
                            child: CircularProgressIndicator(
                          color: Colors.grey[300],
                        )),
                      ),
                    if (AppCubit.get(context).searchModel != null &&
                        state is! GetSearchDataLoadingState)
                      defaultPageNumberRow(
                        context: context,
                        page: page,
                        totalPages:
                            AppCubit.get(context).searchModel!.totalPages,
                        onBackPressed: () {
                          setState(() {
                            page -= 1;
                            AppCubit.get(context).getSearchInfo(
                                text:
                                    AppCubit.get(context).searchController.text,
                                page: page);
                          });
                        },
                        onNextPressed: () {
                          setState(() {
                            page += 1;
                            AppCubit.get(context).getSearchInfo(
                                text:
                                    AppCubit.get(context).searchController.text,
                                page: page);
                          });
                        },
                      ),
                    if (AppCubit.get(context).searchModel != null &&
                        state is! GetSearchDataLoadingState)
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 80.0,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildMovieCard({
    required BuildContext context,
    required SearchResults results,
  }) =>
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MovieScreen(
                searchMovie: results,
              ),
            ),
          );
        },
        child: Container(
          height: MediaQuery.of(context).size.height / 4.0,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Image(
                    image: NetworkImage(
                      '$imageLink${results.posterPath.toString()}',
                    ),
                    // height: MediaQuery.of(context).size.height / 5.0,
                  ),
                  height: MediaQuery.of(context).size.height / 4.0,
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
                        height: MediaQuery.of(context).size.height / 80.0,
                      ),
                      Text(
                        'Date : ${results.releaseDate.toString()}',
                        style: Theme.of(context).textTheme.caption!.copyWith(
                              height: 0.5,
                              color: Colors.grey[400],
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
