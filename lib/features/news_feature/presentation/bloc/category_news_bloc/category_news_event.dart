part of 'category_news_bloc.dart';

@immutable
abstract class CategoryNewsEvent extends Equatable {
  const CategoryNewsEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryNewsEvent extends CategoryNewsEvent {
  final String category;

  const GetCategoryNewsEvent(this.category);

  @override
  List<Object> get props => [category];
}