import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/features/news_feature/presentation/bloc/category_news_bloc/category_news_bloc.dart';
import 'package:news/features/news_feature/presentation/widgets/article_tile.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  String categoryName = 'general';
  List<String> categoriesList = [
    'General', 'Entertainment', 'Health', 'Sports', 'Business', 'Technology', 'Science'
  ];

  @override
  void initState() {
    super.initState();
    context.read<CategoryNewsBloc>().add(GetCategoryNewsEvent(categoryName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // context.read<CategoryNewsBloc>().add(GetCategoryNewsEvent('general'));
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
              builder: (context, state) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: categoriesList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // setState(() {
                        //   categoryName = categoriesList[index].toLowerCase();
                        // });
                        categoryName = categoriesList[index].toLowerCase();
                        context.read<CategoryNewsBloc>().add(GetCategoryNewsEvent(categoryName));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: categoryName == categoriesList[index].toLowerCase()
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: categoryName == categoriesList[index].toLowerCase()
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              categoriesList[index],
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: categoryName == categoriesList[index].toLowerCase()
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
          const SizedBox(height: 20),

          // Vertical list of articles based on selected category
          Expanded(
            child: BlocBuilder<CategoryNewsBloc, CategoryNewsState>(
              builder: (context, state) {
                if (state is CategoryNewsLoading) {
                  return const Center(child: SpinKitCircle(size: 50, color: Colors.blue));
                } else if (state is CategoryNewsLoaded) {

                  if (state.selectedCategory != categoryName) {

                    return const Center(child: SpinKitCircle(size: 50, color: Colors.blue));
                  }
                  if (state.articles.isEmpty) {
                    return Center(child: Text('No news found for ${categoryName.toUpperCase()}.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.articles.length,
                    itemBuilder: (context, index) {
                      return ArticleTile(article: state.articles[index]);
                    },
                  );
                } else if (state is CategoryNewsError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                // Initial state or unexpected state
                return const Center(child: Text('Select a category to view news.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}