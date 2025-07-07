import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/usecases/get_top_headlines.dart';
import 'package:flutter/cupertino.dart';

part 'top_headlines_event.dart';
part 'top_headlines_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String NETWORK_FAILURE_MESSAGE = 'Network Failure';
const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected error';

class TopHeadlinesBloc extends Bloc<TopHeadlinesEvent, TopHeadlinesState> {
  final GetTopHeadlines getTopHeadlines;

  TopHeadlinesBloc({
    required this.getTopHeadlines,
  }) : super(TopHeadlinesInitial()) {
    on<GetTopHeadlinesEvent>(_onGetTopHeadlinesEvent);
  }

  void _onGetTopHeadlinesEvent(GetTopHeadlinesEvent event, Emitter<TopHeadlinesState> emit) async {
    emit(TopHeadlinesLoading());
    final failureOrArticles = await getTopHeadlines(TopHeadlinesParams(channelName: event.channelName));
    failureOrArticles.fold(
          (failure) => emit(TopHeadlinesError(_mapFailureToMessage(failure))),
          (articles) => emit(TopHeadlinesLoaded(articles: articles, identifier: event.channelName)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      // case NetworkFailure: // Add NetworkFailure handling
      //   return NETWORK_FAILURE_MESSAGE;
      default:
        return UNEXPECTED_FAILURE_MESSAGE;
    }
  }
}
