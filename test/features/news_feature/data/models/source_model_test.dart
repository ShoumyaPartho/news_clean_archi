import 'package:flutter_test/flutter_test.dart';
import 'package:news/features/news_feature/data/models/source_model.dart';
import 'package:news/features/news_feature/domain/entities/source_entity.dart';

void main() {
  const tSourceModel = SourceModel(
    id: 'bbc-news',
    name: 'BBC News',
  );

  final Map<String, dynamic> tSourceJson = {
    "id": "bbc-news",
    "name": "BBC News",
  };

  group('SourceModel', () {
    test(
      'should be a subclass of SourceEntity',
          () async {
        // Assert
        expect(tSourceModel, isA<SourceEntity>());
      },
    );

    group('fromJson', () {
      test(
        'should return a valid SourceModel when the JSON is valid',
            () async {
          // Arrange
          final Map<String, dynamic> jsonMap = tSourceJson;

          // Act
          final result = SourceModel.fromJson(jsonMap);

          // Assert
          expect(result, equals(tSourceModel));
        },
      );

    });

    group('toJson', () {
      test(
        'should return a JSON map containing the proper data',
            () async {
          // Act
          final result = tSourceModel.toJson();

          // Assert
          expect(result, equals(tSourceJson));
        },
      );

    });
  });
}
