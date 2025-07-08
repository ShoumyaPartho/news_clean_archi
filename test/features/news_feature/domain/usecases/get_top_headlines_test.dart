import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/entities/source_entity.dart';
import 'package:news/features/news_feature/domain/repositories/article_repository.dart';
import 'package:news/features/news_feature/domain/usecases/get_top_headlines.dart';
import 'get_top_headlines_test.mocks.dart';

@GenerateMocks([ArticleRepository])

void main(){
  late GetTopHeadlines usecase;
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
    usecase = GetTopHeadlines(mockArticleRepository);
  });

  group('GetTopHeadlines', (){
    test(
      'should get list of articles for the given channel from repository',
        () async{
          // Arrange
          when(mockArticleRepository.getTopHeadlines(any))
              .thenAnswer((_) async => Right(tArticleList));

          // Act
          final result = await usecase(const TopHeadlinesParams(channelName: tChannelName));

          // Assert
          expect(result, Right(tArticleList));
          verify(mockArticleRepository.getTopHeadlines(tChannelName));
          verifyNoMoreInteractions(mockArticleRepository);
      },
    );
  });
}