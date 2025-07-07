import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/features/news_feature/presentation/bloc/top_headlines_bloc/top_headlines_bloc.dart';
import 'package:news/features/news_feature/presentation/bloc/category_news_bloc/category_news_bloc.dart';
import 'package:news/features/news_feature/presentation/pages/splash_screen.dart';
import 'injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<TopHeadlinesBloc>(
          create: (_) => di.sl<TopHeadlinesBloc>(),
        ),
        BlocProvider<CategoryNewsBloc>(
          create: (_) => di.sl<CategoryNewsBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            color: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}