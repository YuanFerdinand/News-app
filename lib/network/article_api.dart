import 'package:dio/dio.dart';
import 'package:news_app/model/response_articles.dart';

class ArticleApi {
  late Response response;
  Future<ResponseArticles> getArticleByFilter(
      String category, String query) async {
    final dio = Dio();
    String url =
        "https://newsapi.org/v2/top-headlines?category=$category&apiKey=9ccc7576ee2f45049ccf965faf6c1a63&q=$query";
    print(url);
    response = await dio.get(url);
    if (response.statusCode == 200) {
      return ResponseArticles.fromJson(response.data);
    } else {
      throw Exception(response.statusMessage);
    }
  }
}
