import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/core/usecases/usecase.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/repositories/article_repository.dart';

class GetCategoryNews implements UseCase<List<ArticleEntity>, CategoryNewsParams> {
  final ArticleRepository repository;

  GetCategoryNews(this.repository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call(CategoryNewsParams params) async {
    return await repository.getCategoryNews(params.category);
  }
}

class CategoryNewsParams extends Equatable {
  final String category;

  const CategoryNewsParams({required this.category});

  @override
  List<Object> get props => [category];
}
