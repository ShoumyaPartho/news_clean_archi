part of 'top_headlines_bloc.dart';

@immutable
abstract class TopHeadlinesState extends Equatable {
  const TopHeadlinesState();

  @override
  List<Object> get props => [];
}

class TopHeadlinesInitial extends TopHeadlinesState {}

class TopHeadlinesLoading extends TopHeadlinesState {}

class TopHeadlinesLoaded extends TopHeadlinesState {
  final List<ArticleEntity> articles;
  final String identifier;

  const TopHeadlinesLoaded({required this.articles, required this.identifier});

  @override
  List<Object> get props => [articles, identifier];
}

class TopHeadlinesError extends TopHeadlinesState {
  final String message;

  const TopHeadlinesError(this.message);

  @override
  List<Object> get props => [message];
}