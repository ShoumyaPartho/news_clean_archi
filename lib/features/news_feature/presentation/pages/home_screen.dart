import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/features/news_feature/presentation/bloc/top_headlines_bloc/top_headlines_bloc.dart';
import 'package:news/features/news_feature/presentation/bloc/category_news_bloc/category_news_bloc.dart';
import 'package:news/features/news_feature/presentation/pages/categories_screen.dart';
import 'package:news/features/news_feature/presentation/widgets/article_tile.dart';
import 'package:news/features/news_feature/presentation/widgets/top_headlines_card.dart';

enum FilterList { bbcNews, bloomberg, abc, cnn, alJazeera }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedTopHeadlineChannel = 'bbc-news';

  @override
  void initState() {
    super.initState();
    context.read<TopHeadlinesBloc>().add(GetTopHeadlinesEvent(_selectedTopHeadlineChannel));
    context.read<CategoryNewsBloc>().add(const GetCategoryNewsEvent('general'));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // context.read<CategoryNewsBloc>().add(const GetCategoryNewsEvent('general'));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CategoriesScreen()),
            );
          },
          icon: Image.asset('images/category_icon.png', height: 30, width: 30),
        ),
        title: Text('News', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700)),
        actions: [
          BlocBuilder<TopHeadlinesBloc, TopHeadlinesState>(
            builder: (context, state) {
              FilterList selectedMenu = FilterList.bbcNews;
              if (state is TopHeadlinesLoaded) {
                switch (state.identifier) {
                  case 'bbc-news':
                    selectedMenu = FilterList.bbcNews;
                    break;
                  case 'bloomberg':
                    selectedMenu = FilterList.bloomberg;
                    break;
                  case 'abc-news':
                    selectedMenu = FilterList.abc;
                    break;
                  case 'cnn':
                    selectedMenu = FilterList.cnn;
                    break;
                  case 'al-jazeera-english':
                    selectedMenu = FilterList.alJazeera;
                    break;
                }
              }
              return PopupMenuButton<FilterList>(
                initialValue: selectedMenu,
                icon: const Icon(Icons.more_vert, color: Colors.black),
                onSelected: (FilterList item) {
                  String newChannelName;
                  switch (item) {
                    case FilterList.bbcNews:
                      newChannelName = 'bbc-news';
                      break;
                    case FilterList.bloomberg:
                      newChannelName = 'bloomberg';
                      break;
                    case FilterList.abc:
                      newChannelName = 'abc-news';
                      break;
                    case FilterList.cnn:
                      newChannelName = 'cnn';
                      break;
                    case FilterList.alJazeera:
                      newChannelName = 'al-jazeera-english';
                      break;
                  }
                  context.read<TopHeadlinesBloc>().add(GetTopHeadlinesEvent(newChannelName));
                  // setState(() {
                  //   _selectedTopHeadlineChannel = newChannelName;
                  // });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                  const PopupMenuItem<FilterList>(value: FilterList.bbcNews, child: Text('BBC News')),
                  const PopupMenuItem<FilterList>(value: FilterList.bloomberg, child: Text('Bloomberg')),
                  const PopupMenuItem<FilterList>(value: FilterList.cnn, child: Text('CNN')),
                  const PopupMenuItem<FilterList>(value: FilterList.alJazeera, child: Text('Al Jazeera')),
                  const PopupMenuItem<FilterList>(value: FilterList.abc, child: Text('ABC News')),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: BlocBuilder<TopHeadlinesBloc, TopHeadlinesState>(
              builder: (context, state) {
                if (state is TopHeadlinesLoading) {
                  return const Center(child: SpinKitCircle(size: 40, color: Colors.blue));
                } else if (state is TopHeadlinesLoaded) {
                  if (state.articles.isEmpty) {
                    return const Center(child: Text('No top headlines found.'));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      return TopHeadlinesCard(article: state.articles[index], width: width);
                    },
                  );
                } else if (state is TopHeadlinesError) {
                  return Center(child: Text('Error loading top headlines: ${state.message}'));
                }
                return const Center(child: Text('Select a news channel for top headlines.'));
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Spacer

          Expanded(
            child: BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
              builder: (context, state) {
                if (state is CategoryNewsLoading) {
                  return const Center(child: SpinKitCircle(size: 50, color: Colors.blue));
                } else if (state is CategoryNewsLoaded) {
                  if (state.articles.isEmpty) {
                    return const Center(child: Text('No category news found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      return ArticleTile(article: state.articles[index]);
                    },
                  );
                } else if (state is CategoryNewsError) {
                  return Center(child: Text('Error loading category news: ${state.message}'));
                }
                return const Center(child: Text('Loading general news...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}