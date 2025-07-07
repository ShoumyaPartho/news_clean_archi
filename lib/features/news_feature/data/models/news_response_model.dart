import 'package:equatable/equatable.dart';
import 'package:news/features/news_feature/data/models/article_model.dart';

class NewsResponseModel extends Equatable {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  const NewsResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    return NewsResponseModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: (json['articles'] as List)
          .map((articleJson) => ArticleModel.fromJson(articleJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles.map((article) => article.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, totalResults, articles];
}
