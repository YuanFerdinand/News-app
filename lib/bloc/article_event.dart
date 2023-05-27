part of 'article_bloc.dart';

@immutable
abstract class ArticleEvent {}

class LoadArticle extends ArticleEvent {
  String category;
  String query;
  LoadArticle({this.category = "", this.query = ""});
}
