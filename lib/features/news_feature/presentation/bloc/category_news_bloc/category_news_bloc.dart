import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/usecases/get_category_news.dart';
import 'package:flutter/cupertino.dart';

part 'category_news_event.dart';
part 'category_news_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';
const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected error';

class CategoryNewsBloc extends Bloc<CategoryNewsEvent, CategoryNewsState> {
  final GetCategoryNews getCategoryNews;

  CategoryNewsBloc({required this.getCategoryNews})
      : super(CategoryNewsInitial()) {
    on<GetCategoryNewsEvent>(_onGetCategoryNewsEvent);
  }

  void _onGetCategoryNewsEvent(GetCategoryNewsEvent event, Emitter<CategoryNewsState> emit) async {
    emit(CategoryNewsLoading());
    final failureOrArticles = await getCategoryNews(CategoryNewsParams(category: event.category));
    failureOrArticles.fold(
          (failure) => emit(CategoryNewsError(_mapFailureToMessage(failure))),
          (articles) => emit(CategoryNewsLoaded(articles: articles, selectedCategory: event.category)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      // case NetworkFailure:
      //   return NETWORK_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
