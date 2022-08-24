import 'package:swipe/data/api/api_helper.dart';
import 'package:swipe/swipe.dart';

class BaseRepository {
  final apiHelper = APIHelper();
  final serverUrl = Swipe.getServerUrl();
  final apiKey = Swipe.apiKey;
}
