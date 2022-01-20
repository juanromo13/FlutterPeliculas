import 'package:flutter/material.dart';
import 'package:peliculas/models/movie.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  Widget _defaultContainer() {
    return Container(
      child: Center(
        child: Icon(Icons.movie_creation_outlined,
            color: Colors.black38, size: 100),
      ),
    );
  }

  @override
  String get searchFieldLabel => 'Buscar pelicula';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
   Widget buildResults(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
        future: moviesProvider.searchMovie(query),
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return _defaultContainer();
          }

          final movies = snapshot.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, int index) => _resultItem(movies[index]));
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _defaultContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
        stream: moviesProvider.suggestionStream,
        builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return _defaultContainer();
          }

          final movies = snapshot.data!;

          return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (_, int index) =>
                  ListTile(
                    title: Text(movies[index].title),
                    onTap: () {
                      query = movies[index].title;
                      showResults(context);
                    },
                  ));
        });
  }
}

class _resultItem extends StatelessWidget {
  final Movie movie;

  const _resultItem(this.movie, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
            placeholder: AssetImage('assets/img/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            width: 50,
            fit: BoxFit.contain),
      ),
      title: Text(movie.title),
      subtitle: Text('${movie.releaseDate}'),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
    );
  }
}
