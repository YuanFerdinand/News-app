import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_app/model/response_articles.dart';
import 'package:news_app/network/article_api.dart';
part 'article_event.dart';
part 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc() : super(ArticleBlocInitial());

  @override
  Stream<ArticleState> mapEventToState(ArticleEvent event) async* {
    if (event is LoadArticle) {
      yield* getArticleByCategory(event.category, event.query);
    }
  }

  Stream<ArticleState> getArticleByCategory(
      String category, String query) async* {
    yield GetArticleWaiting();
    try {
      ResponseArticles response =
          await ArticleApi().getArticleByFilter(category, query);
      yield GetArticleSuccess(responseArticles: response);
    } catch (e) {
      yield GetArticleError(errorMessage: e.toString());
    }
  }
}
