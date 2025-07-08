import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/error/failure.dart';
import 'package:news/features/news_feature/domain/entities/article_entity.dart';
import 'package:news/features/news_feature/domain/usecases/get_top_headlines.dart';
import 'package:news/features/news_feature/presentation/bloc/top_headlines_bloc/top_headlines_bloc.dart';
import 'top_headlines_bloc_test.mocks.dart';

@GenerateMocks([GetTopHeadlines])

void main() {
  late TopHeadlinesBloc bloc;
  late MockGetTopHeadlines mockGetTopHeadlines;

  const tArticleList = [
    ArticleEntity(
      source: null,
      author: 'Test Author',
      title: 'Test Title',
      description: 'Test Description',
      url: 'http://test.com/article',
      urlToImage: 'http://test.com/image.jpg',
      publishedAt: '2024-07-08T12:00:00Z',
      content: 'Test Content',
    ),
  ];

  const tChannelName = 'bbc-news';
  final tTopHeadlinesParams = TopHeadlinesParams(channelName: tChannelName);

  setUp(() {
    mockGetTopHeadlines = MockGetTopHeadlines();
    bloc = TopHeadlinesBloc(getTopHeadlines: mockGetTopHeadlines);
  });

  test('initial state should be TopHeadlinesInitial', () {
    expect(bloc.state, equals(TopHeadlinesInitial()));
  });

  group('GetTopHeadlinesEvent', () {
    blocTest<TopHeadlinesBloc, TopHeadlinesState>(
      'should emit [TopHeadlinesLoading, TopHeadlinesLoaded] when data is gotten successfully',
      build: () {
        // Arrange
        when(mockGetTopHeadlines(tTopHeadlinesParams))
            .thenAnswer((_) async => const Right(tArticleList));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTopHeadlinesEvent(tChannelName)),
      expect: () => [
        TopHeadlinesLoading(),
        const TopHeadlinesLoaded(articles: tArticleList, identifier: tChannelName),
      ],
      verify: (_) {
        verify(mockGetTopHeadlines(tTopHeadlinesParams));
      },
    );

    blocTest<TopHeadlinesBloc, TopHeadlinesState>(
      'should emit [TopHeadlinesLoading, TopHeadlinesError] when getting data fails due to ServerFailure',
      build: () {
        // Arrange
        when(mockGetTopHeadlines(tTopHeadlinesParams))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTopHeadlinesEvent(tChannelName)),
      expect: () => [
        TopHeadlinesLoading(),
        const TopHeadlinesError(SERVER_FAILURE_MESSAGE),
      ],
      verify: (_) {
        verify(mockGetTopHeadlines(tTopHeadlinesParams));
      },
    );
  });
}
