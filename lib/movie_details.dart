import 'package:flutter/material.dart';
import 'main.dart';

class MovieDetailsScreen extends StatelessWidget {
    final Movie movie;

    const MovieDetailsScreen({super.key, required this.movie});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(movie.title)
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text('Directed by: ${movie.director}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Image.network(movie.images.elementAt(1)),
                        SizedBox(height: 8),
                        Text(movie.plot, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Image.network(movie.images.elementAt(2)),
                        SizedBox(height: 8),
                        Text(movie.genre, style: TextStyle(fontSize: 16))
                    ]
                )
            )
        );
    }
}
