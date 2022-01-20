import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/movie_search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Peliculas en cines'),
        actions: [
          IconButton(
              icon: Icon(Icons.search_outlined),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()))
        ],
      ),
      body: ListView(
        children: [
          // Main cards
          CardSwiper(movies: moviesProvider.onDisplayMovies),
          // Movies slider
          MovieSlider(
              movies: moviesProvider.popularMovies,
              onNextPage: moviesProvider.getPopularMovies)
        ],
      ),
    );
  }
}
