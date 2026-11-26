
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://movies-api.accel.li/api/v2/';

 
  static const String listMovies = 'list_movies.json'; // search, browse, home
  static const String movieDetails = 'movie_details.json'; // details screen
  static const String movieSuggestions = 'movie_suggestions.json'; // similar

  
  static const String limitKey = 'limit';
  static const String pageKey = 'page';
  static const String queryTermKey = 'query_term';
  static const String genreKey = 'genre';
  static const String sortByKey = 'sort_by';
  static const String orderByKey = 'order_by';
  static const String minimumRatingKey = 'minimum_rating';
  static const String qualityKey = 'quality';
  static const String movieIdKey = 'movie_id';
  static const String withImagesKey = 'with_images';
  static const String withCastKey = 'with_cast';

  static const int defaultLimit = 20;
  static const int maxLimit = 50;
  static const int firstPage = 1;
  static const Duration searchDebounce = Duration(milliseconds: 500);
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String sortTitle = 'title';
  static const String sortYear = 'year';
  static const String sortRating = 'rating';
  static const String sortPeers = 'peers';
  static const String sortSeeds = 'seeds';
  static const String sortDownloadCount = 'download_count';
  static const String sortLikeCount = 'like_count';
  static const String sortDateAdded = 'date_added';

  
  static const String orderDesc = 'desc';
  static const String orderAsc = 'asc';


  static const List<String> genres = [
    'action',
    'adventure',
    'animation',
    'biography',
    'comedy',
    'crime',
    'documentary',
    'drama',
    'family',
    'fantasy',
    'film-noir',
    'history',
    'horror',
    'music',
    'musical',
    'mystery',
    'romance',
    'sci-fi',
    'sport',
    'thriller',
    'war',
    'western',
  ];
}