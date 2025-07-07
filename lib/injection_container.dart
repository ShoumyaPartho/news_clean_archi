import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:news/core/network/network_info.dart';
import 'package:news/features/news_feature/domain/repositories/article_repository.dart';
import 'package:news/features/news_feature/domain/usecases/get_category_news.dart';
import 'package:news/features/news_feature/domain/usecases/get_top_headlines.dart';
import 'package:news/features/news_feature/data/datasources/news_remote_data_source.dart';
import 'package:news/features/news_feature/data/repositories/article_repository_impl.dart';
import 'package:news/features/news_feature/presentation/bloc/top_headlines_bloc/top_headlines_bloc.dart';
import 'package:news/features/news_feature/presentation/bloc/category_news_bloc/category_news_bloc.dart';

final sl = GetIt.instance;

void init() {

  // BLoCs
  // TopHeadlinesBloc
  sl.registerFactory(
        () => TopHeadlinesBloc(
      getTopHeadlines: sl(),
    ),
  );
  // CategoryNewsBloc
  sl.registerFactory(
        () => CategoryNewsBloc(
      getCategoryNews: sl(), // Only inject GetCategoryNews
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetTopHeadlines(sl()));
  sl.registerLazySingleton(() => GetCategoryNews(sl()));

  // Repository
  sl.registerLazySingleton<ArticleRepository>(
        () => ArticleRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NewsRemoteDataSource>(
        () => NewsRemoteDataSourceImpl(client: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}