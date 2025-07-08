import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/usecases/get_category_news.dart';
import 'package:news/features/news_feature/presentation/bloc/category_news_bloc/category_news_bloc.dart';
import 'category_news_bloc_test.mocks.dart';

@GenerateMocks([GetCategoryNews])

void main() {
  late CategoryNewsBloc bloc;
  late MockGetCategoryNews mockGetCategoryNews;

  const tArticleList = [
    ArticleEntity(
      source: null,
      author: 'Category Author',
      title: 'Category Title',
      description: 'Category Description',
      url: 'http://test.com/category_article',
      urlToImage: 'http://test.com/category_image.jpg',
      publishedAt: '2024-07-08T13:00:00Z',
      content: 'Category Content',
    ),
  ];

  const tCategory = 'sports';
  final tCategoryNewsParams = CategoryNewsParams(category: tCategory);

  setUp(() {
    mockGetCategoryNews = MockGetCategoryNews();
    bloc = CategoryNewsBloc(getCategoryNews: mockGetCategoryNews);
  });

  test('initial state should be CategoryNewsInitial', () {
    expect(bloc.state, equals(CategoryNewsInitial()));
  });

  group('GetCategoryNewsEvent', () {
    blocTest<CategoryNewsBloc, CategoryNewsState>(
      'should emit [CategoryNewsLoading, CategoryNewsLoaded] when data is gotten successfully',
      build: () {
        // Arrange
        when(mockGetCategoryNews(tCategoryNewsParams))
            .thenAnswer((_) async => const Right(tArticleList));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetCategoryNewsEvent(tCategory)),
      expect: () => [
        CategoryNewsLoading(),
        const CategoryNewsLoaded(articles: tArticleList, selectedCategory: tCategory),
      ],
      verify: (_) {
        verify(mockGetCategoryNews(tCategoryNewsParams));
      },
    );

    blocTest<CategoryNewsBloc, CategoryNewsState>(
      'should emit [CategoryNewsLoading, CategoryNewsError] when getting data fails due to ServerFailure',
      build: () {
        // Arrange
        when(mockGetCategoryNews(tCategoryNewsParams))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetCategoryNewsEvent(tCategory)),
      expect: () => [
        CategoryNewsLoading(),
        const CategoryNewsError(SERVER_FAILURE_MESSAGE),
      ],
      verify: (_) {
        verify(mockGetCategoryNews(tCategoryNewsParams));
      },
    );

  });
}