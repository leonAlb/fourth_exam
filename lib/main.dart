import 'dart:convert';

import 'package:flutter/material.dart';
import 'movie_details.dart';
import 'package:flutter/services.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Fourth Exam',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const MyScreen()
        );
    }
}

class MyScreen extends StatelessWidget {
    const MyScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return const Scaffold(body: MyJsonWidget());
    }
}

class MyJsonWidget extends StatefulWidget {
    const MyJsonWidget({super.key});

    @override
    State<MyJsonWidget> createState() => _MyJsonWidgetState();
}

// I changed from http to JSON because i interpreted
// "You’ll find URLs for the images from the demo data"
// in a way that points at the provided json file
class _MyJsonWidgetState extends State<MyJsonWidget> {
    List<Movie> movies = [];
    bool isLoading = true;

    @override
    void initState() {
        super.initState();
        _loadMovies().then((loadedMovies) {
                setState(() {
                        movies = loadedMovies;
                        isLoading = false;
                    });
            });
    }

    Future<List<Movie>> _loadMovies() async {
        await Future.delayed(const Duration(seconds: 1));
        final String jsonString = await rootBundle.loadString('assets/data/movie_data.json');
        final List<dynamic> jsonList = jsonDecode(jsonString);

        return List<Movie>.generate(
            jsonList.length,
            (index) => Movie.fromJson(jsonList[index] as Map<String, dynamic>)
        );
    }

    @override
    Widget build(BuildContext context) {
        if (isLoading) {
            return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
            itemCount: movies.length,
            prototypeItem: CustomMovieListTile(
                movie: movies.first
            ),
            itemBuilder: (context, index) {
                return CustomMovieListTile(
                    movie: movies[index]
                );
            }
        );
    }
}

class Movie {
    final String title;
    final String director;
    final List<String> images;
    final String plot;
    final String genre;

    Movie({required this.title, required this.director, required this.images, required this.plot, required this.genre});

    factory Movie.fromJson(Map<String, dynamic> json) {
        return Movie(
            title: json['Title'],
            director: json['Director'],
            images: List<String>.from(json['Images']),
            plot: json['Plot'],
            genre: json['Genre']
        );
    }
}

class CustomMovieListTile extends StatelessWidget {
    final Movie movie;

    const CustomMovieListTile({super.key, required this.movie});

    @override
    Widget build(BuildContext context) {
        return Container(
            height: 100,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        spreadRadius: 1,
                        blurRadius: 3
                    )
                ]
            ),
            child:
            Material(
                color: Colors.white,
                child: InkWell(
                    onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MovieDetailsScreen(movie: movie))
                        );
                    },
                    splashColor: Colors.blue.withAlpha(76),
                    hoverColor: Colors.blue.withAlpha(25),
                    highlightColor: Colors.blue.withAlpha(51),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            children: [
                                CircleAvatar(
                                    backgroundImage: NetworkImage(movie.images.elementAt(0)),
                                    radius: 30
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text(
                                                movie.title,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                            ),
                                            Text(
                                                movie.director,
                                                style: TextStyle(fontSize: 14, color: Colors.blueGrey)
                                            )
                                        ]
                                    )
                                ),
                                Icon(Icons.arrow_forward)
                            ]
                        )
                    )
                )
            )
        );
    }
}
