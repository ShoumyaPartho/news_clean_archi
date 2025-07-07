import 'package:dartz/dartz.dart';
import 'package:news/core/error/exceptions.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/core/network/network_info.dart';
import 'package:news/features/news_feature/data/datasources/news_remote_data_source.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ArticleEntity>>> getTopHeadlines(String channelName) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticlesResponse = await remoteDataSource.getTopHeadlines(channelName);
        // Map ArticleModel (from response) to ArticleEntity (for domain)
        return Right(remoteArticlesResponse.articles);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getCategoryNews(String category) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteArticlesResponse = await remoteDataSource.getCategoryNews(category);
        // Map ArticleModel (from response) to ArticleEntity (for domain)
        return Right(remoteArticlesResponse.articles);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(ServerFailure());
    }
  }
}