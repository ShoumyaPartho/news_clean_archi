import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/entities/source_entity.dart';
import 'package:news/features/news_feature/domain/repositories/article_repository.dart';
import 'package:news/features/news_feature/domain/usecases/get_category_news.dart';

import 'get_category_news_test.mocks.dart';

@GenerateMocks([ArticleRepository])

void main(){
  late GetCategoryNews usecase;
  late MockArticleRepository mockArticleRepository;

  const tChannelName = 'bbc-news';
  final tSource = SourceEntity(id: tChannelName, name: 'BBC News');
  final tArticle = ArticleEntity(
    source: tSource,
    author: 'Author One',
    title: 'Test Article Title',
    description: 'Test Description',
    url: 'http://test.com',
    urlToImage: 'http://test.com/image.jpg',
    publishedAt: '2023-01-01T12:00:00Z',
    content: 'Test Content',
  );
  final List<ArticleEntity> tArticleList = [tArticle];

  setUp((){
    mockArticleRepository = MockArticleRepository();
    usecase = GetCategoryNews(mockArticleRepository);
  });

  group('GetCategoryNews', (){
    test(
      'should get category news from repository when called with a category name',
        () async{
          // arrange
          when(mockArticleRepository.getCategoryNews(any))
              .thenAnswer((_) async => Right(tArticleList));

          // act
          final result = await usecase(CategoryNewsParams(category: 'general'));

          // assert
          expect(result, Right(tArticleList));
          verify(mockArticleRepository.getCategoryNews('general'));
          verifyNoMoreInteractions(mockArticleRepository);
        },
    );
  }
  );
}