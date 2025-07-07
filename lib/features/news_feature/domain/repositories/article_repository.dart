import 'package:dartz/dartz.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines(String channelName);
  Future<Either<Failure, List<ArticleEntity>>> getCategoryNews(String category);
}
