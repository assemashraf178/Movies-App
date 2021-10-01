import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/cubit/states.dart';
import 'package:movies_app/models/movies_model.dart';
import 'package:movies_app/modules/movie/movie_screen.dart';
import 'package:movies_app/modules/movies_list/movies_list_screen.dart';

import 'constants.dart';

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blueGrey,
  bool isUpperCase = true,
  double radius = 15.0,
  double height = 40.0,
  required VoidCallback function,
  required String text,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(color: Colors.white),
        ),
        elevation: 50.0,
      ),
    );

Widget defaultTextFormField({
  required String hint,
  required IconData prefixIcon,
  required BuildContext context,
  required TextInputType type,
  required Function validator,
  required TextEditingController controller,
  bool isPassword = false,
  IconButton? suffixIcon,
  Function? onChange,
  Function? onSubmit,
}) =>
    Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.blueGrey.withOpacity(0.1),
      ),
      child: TextFormField(
        onFieldSubmitted: onSubmit != null
            ? (s) {
                onSubmit(s);
              }
            : null,
        onChanged: onChange != null
            ? (s) {
                onChange(s);
              }
            : null,
        controller: controller,
        validator: (value) {
          validator(value);
        },
        keyboardType: type,
        obscureText: isPassword,
        style: const TextStyle(
          textBaseline: TextBaseline.alphabetic,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: Colors.grey[200],
          ),
          suffix: suffixIcon,
          contentPadding: EdgeInsets.all(
            (MediaQuery.of(context).size.width) / 50.0,
          ),
          isCollapsed: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(
              color: Color(0xff314050),
              width: 1,
            ),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.grey[200],
          ),
          labelText: hint,
        ),
      ),
    );

Card defaultLoading({
  required BuildContext context,
}) =>
    Card(
      child: Padding(
        padding: EdgeInsets.all(
          (MediaQuery.of(context).size.height) / 40.0,
        ),
        child: const CircularProgressIndicator(),
      ),
      elevation: 5,
    );

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
            mainAxisAlignment: MainAxisAlignment.center,
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
                          style: Theme.of(context).textTheme.caption!.copyWith(
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

Widget buildMoviesList({
  required BuildContext context,
  required MoviesModel model,
  required AppStates state,
  required int page,
  required int totalPages,
  required Function onBackPressed,
  required Function onNextPressed,
}) =>
    SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return buildMovieCard(
                    context: context, results: model.results[index]);
              },
              separatorBuilder: (BuildContext context, int index) => SizedBox(
                height: MediaQuery.of(context).size.height / 50.0,
              ),
              itemCount: model.results.length,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80.0,
            ),
            Row(
              children: [
                if (page <= totalPages && page != 1)
                  FloatingActionButton(
                    onPressed: () {
                      onBackPressed();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                    backgroundColor: const Color(0xff314250),
                  ),
                const Spacer(),
                Card(
                  color: const Color(0xff314250),
                  elevation: 5.0,
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height / 100.0,
                    ),
                    child: Text(
                      '$page : $totalPages',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Colors.grey[200],
                          ),
                    ),
                  ),
                ),
                const Spacer(),
                if (page < totalPages)
                  FloatingActionButton(
                    onPressed: () {
                      onNextPressed();
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

Widget defaultPageNumberRow({
  required BuildContext context,
  required int page,
  required int totalPages,
  required Function onBackPressed,
  required Function onNextPressed,
}) =>
    Row(
      children: [
        if (page <= totalPages && page != 1)
          FloatingActionButton(
            onPressed: () {
              onBackPressed();
            },
            child: const Icon(
              Icons.arrow_back_ios,
            ),
            backgroundColor: const Color(0xff314250),
          ),
        const Spacer(),
        Card(
          color: const Color(0xff314250),
          elevation: 5.0,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.height / 100.0,
            ),
            child: Text(
              '$page : $totalPages',
              style: Theme.of(context).textTheme.headline6!.copyWith(
                    color: Colors.grey[200],
                  ),
            ),
          ),
        ),
        const Spacer(),
        if (page < totalPages)
          FloatingActionButton(
            onPressed: () {
              onNextPressed();
            },
            child: const Icon(
              Icons.arrow_forward_ios,
            ),
            backgroundColor: const Color(0xff314250),
          ),
      ],
    );

Widget buildMovieKind({
  required BuildContext context,
  required String text,
  required String navigatorText,
  required Size size,
  required List<Results> results,
}) =>
    Column(
      children: [
        Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.headline5!.copyWith(
                    color: Colors.white,
                  ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MoviesListScreen(
                      modelName: navigatorText,
                    ),
                  ),
                );
              },
              child: const Text(
                'Show All',
              ),
            )
          ],
        ),
        SizedBox(
          height: size.height / 50.0,
        ),
        CarouselSlider(
          items: results
              .map((e) => InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MovieScreen(
                                  movie: e,
                                )),
                      );
                    },
                    child: Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          size.width / 15.0,
                        ),
                      ),
                      child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: const Color(0xb51c262f),
                        child: Padding(
                          padding: EdgeInsets.all(
                            size.height / 50.0,
                          ),
                          child: Stack(
                            alignment: AlignmentDirectional.topCenter,
                            children: [
                              Image(
                                image: NetworkImage(
                                  '$imageLink${e.backdropPath.toString()}',
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                              Align(
                                alignment: AlignmentDirectional.bottomCenter,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width / 50.0,
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                    e.originalTitle.toString(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
          options: CarouselOptions(
            height: size.height / 3.4,
            autoPlay: true,
            initialPage: 0,
            reverse: true,
            autoPlayInterval: const Duration(
              seconds: 2,
            ),
            autoPlayAnimationDuration: const Duration(
              seconds: 2,
            ),
            autoPlayCurve: Curves.decelerate,
            pauseAutoPlayOnTouch: true,
            scrollDirection: Axis.horizontal,
            scrollPhysics: const BouncingScrollPhysics(),
            enlargeCenterPage: true,
            pauseAutoPlayOnManualNavigate: true,
            // pageSnapping: true,
            // pauseAutoPlayInFiniteScroll: true,
          ),
        ),
        SizedBox(
          height: size.height / 50.0,
        ),
      ],
    );
