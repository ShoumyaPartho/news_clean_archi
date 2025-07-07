part of 'category_news_bloc.dart';

@immutable
abstract class CategoryNewsState extends Equatable {
  const CategoryNewsState();

  @override
  List<Object> get props => [];
}

class CategoryNewsInitial extends CategoryNewsState {}

class CategoryNewsLoading extends CategoryNewsState {}

class CategoryNewsLoaded extends CategoryNewsState {
  final List<ArticleEntity> articles;
  final String selectedCategory;

  const CategoryNewsLoaded({required this.articles, required this.selectedCategory});

  @override
  List<Object> get props => [articles, selectedCategory];
}

class CategoryNewsError extends CategoryNewsState {
  final String message;

  const CategoryNewsError(this.message);

  @override
  List<Object> get props => [message];
}
