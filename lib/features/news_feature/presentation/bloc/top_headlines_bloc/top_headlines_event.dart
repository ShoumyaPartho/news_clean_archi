part of 'top_headlines_bloc.dart';

@immutable
abstract class TopHeadlinesEvent extends Equatable {
  const TopHeadlinesEvent();

  @override
  List<Object> get props => [];
}

class GetTopHeadlinesEvent extends TopHeadlinesEvent {
  final String channelName;

  const GetTopHeadlinesEvent(this.channelName);

  @override
  List<Object> get props => [channelName];
}