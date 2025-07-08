import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:news/core/network/network_info.dart';
import 'network_info_test.mocks.dart';

@GenerateMocks([Connectivity])

void main() {
  late NetworkInfoImpl networkInfo;
  late MockConnectivity mockConnectivity;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfo = NetworkInfoImpl(mockConnectivity);
  });

  group('isConnected', () {
    test(
      'should return true when connectivity result contains mobile',
          () async {
        // Arrange
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.mobile]);

        // Act
        final result = await networkInfo.isConnected;

        // Assert
        verify(mockConnectivity.checkConnectivity());
        expect(result, true);
      },
    );

    test(
      'should return true when connectivity result contains wifi',
          () async {
        // Arrange
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.wifi]);

        // Act
        final result = await networkInfo.isConnected;

        // Assert
        verify(mockConnectivity.checkConnectivity());
        expect(result, true);
      },
    );

    test(
      'should return false when connectivity result contains none',
          () async {
        // Arrange
        when(mockConnectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);

        // Act
        final result = await networkInfo.isConnected;

        // Assert
        verify(mockConnectivity.checkConnectivity());
        expect(result, false);
      },
    );
  });
}
