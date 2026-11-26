import 'package:movies/apis/constants.dart';

/// The ways the browse grid can be ordered.
enum BrowseSort {
  latest('Latest', ApiConstants.sortDateAdded, ApiConstants.orderDesc),
  topRated('Top rated', ApiConstants.sortRating, ApiConstants.orderDesc),
  mostPopular('Most popular', ApiConstants.sortDownloadCount, ApiConstants.orderDesc),
  newest('Release year', ApiConstants.sortYear, ApiConstants.orderDesc),
  title('Title (A-Z)', ApiConstants.sortTitle, ApiConstants.orderAsc);

  final String label;
  final String sortBy;
  final String orderBy;

  const BrowseSort(this.label, this.sortBy, this.orderBy);
}
