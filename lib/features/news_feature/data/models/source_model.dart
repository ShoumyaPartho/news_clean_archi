import 'package:news/features/news_feature/domain/entities/source_entity.dart';

class SourceModel extends SourceEntity {
  const SourceModel({
    String? id,
    String? name,
  }) : super(id: id, name: name);

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}