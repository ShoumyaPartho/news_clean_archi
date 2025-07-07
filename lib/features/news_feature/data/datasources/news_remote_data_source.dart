import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/core/error/exceptions.dart';
import 'package:news/features/news_feature/data/models/news_response_model.dart';

abstract class NewsRemoteDataSource {
  Future<NewsResponseModel> getTopHeadlines(String channelName);
  Future<NewsResponseModel> getCategoryNews(String category);
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final http.Client client;
  final String _apiKey = 'fa4a7af6c9274db6adfcbba99e0db83a';

  NewsRemoteDataSourceImpl({required this.client});

  @override
  Future<NewsResponseModel> getTopHeadlines(String channelName) async {
    final response = await client.get(
    Uri.parse('https://newsapi.org/v2/top-headlines?sources=$channelName&apiKey=$_apiKey'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return NewsResponseModel.fromJson(json.decode(response.body));
    }
  else {
    throw ServerException();
  }
}

  @override
  Future<NewsResponseModel> getCategoryNews(String category) async {
    final response = await client.get(
      Uri.parse('https://newsapi.org/v2/everything?q=$category&apiKey=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NewsResponseModel.fromJson(json.decode(response.body));
    }
    else {
      throw ServerException();
    }
  }
}