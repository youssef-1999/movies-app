import 'package:movies/features/home/domain/entities/movie_entity.dart';
import 'package:movies/gen/assets.gen.dart';

// Temporary local data until the movies API is wired up.
// `id` is the movie's id in the API, used to open the details screen.
final List<MovieEntity> dummyMovies = [
  MovieEntity(
    id: 13729,
    name: 'Hobbs & Shaw',
    image: Assets.posters.hobbsShaw.path,
    rating: 6.4,
  ),
  MovieEntity(
    id: 15862,
    name: '1917',
    image: Assets.posters.movie1917.path,
    rating: 7.7,
  ),
  MovieEntity(
    id: 1649,
    name: 'Iron Man 3',
    image: Assets.posters.ironMan3.path,
    rating: 7.1,
  ),
  MovieEntity(
    id: 42950,
    name: 'Doctor Strange in the Multiverse of Madness',
    image: Assets.posters.doctorStrange.path,
    rating: 7.6,
  ),
  MovieEntity(
    id: 618,
    name: 'Captain America: The First Avenger',
    image: Assets.posters.captainAmerica.path,
    rating: 7.7,
  ),
  MovieEntity(
    id: 13106,
    name: 'Avengers: Endgame',
    image: Assets.posters.avengersEndgame.path,
    rating: 8.4,
  ),
];
