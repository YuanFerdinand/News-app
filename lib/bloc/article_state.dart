part of 'article_bloc.dart';

@immutable
abstract class ArticleState {}

class ArticleBlocInitial extends ArticleState {}

class GetArticleWaiting extends ArticleState {}

class GetArticleError extends ArticleState {
  final String errorMessage;
  GetArticleError({required this.errorMessage});
}

class GetArticleSuccess extends ArticleState {
  ResponseArticles responseArticles;
  GetArticleSuccess({required this.responseArticles});
}
