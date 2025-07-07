import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/core/usecases/usecase.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/repositories/article_repository.dart';

class GetTopHeadlines implements UseCase<List<ArticleEntity>, TopHeadlinesParams> {
  final ArticleRepository repository;

  GetTopHeadlines(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(TopHeadlinesParams params) async {
    return await repository.getTopHeadlines(params.channelName);
  }
}

class TopHeadlinesParams extends Equatable {
  final String channelName;

  const TopHeadlinesParams({required this.channelName});

  @override
  List<Object> get props => [channelName];
}
