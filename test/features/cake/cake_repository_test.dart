import 'dart:convert';
import 'dart:io';

import 'package:cake_it_app/src/features/cake/data/cake_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('CakeRepository', () {
    group('fetchCakes', () {
      test('returns a list of Cake objects on 200', () async {
        final client = MockClient((_) async => http.Response(
              json.encode([
                {
                  'title': 'Battenberg',
                  'desc': 'Marzipan wrapped',
                  'image': 'https://a.com/1.jpg'
                },
                {
                  'title': 'Eclair',
                  'desc': 'Choux pastry',
                  'image': 'https://a.com/2.jpg'
                },
              ]),
              200,
            ));

        final repo = CakeRepository(client: client);
        final cakes = await repo.fetchCakes();

        expect(cakes.length, 2);
        expect(cakes[0].title, 'Battenberg');
        expect(cakes[1].title, 'Eclair');
      });

      test('silently skips non-map entries in the JSON array', () async {
        final client = MockClient((_) async => http.Response(
              json.encode([
                {'title': 'Valid', 'desc': 'Yes', 'image': ''},
                'not a map',
                42,
              ]),
              200,
            ));

        final repo = CakeRepository(client: client);
        final cakes = await repo.fetchCakes();

        expect(cakes.length, 1);
        expect(cakes[0].title, 'Valid');
      });

      test('throws CakeFetchException on non-200 status', () async {
        final client =
            MockClient((_) async => http.Response('Server Error', 500));

        final repo = CakeRepository(client: client);

        expect(
          () => repo.fetchCakes(),
          throwsA(
            isA<CakeFetchException>().having(
              (e) => e.message,
              'message',
              contains('500'),
            ),
          ),
        );
      });

      test('throws CakeFetchException on malformed JSON', () async {
        final client = MockClient((_) async => http.Response('not json!', 200));

        final repo = CakeRepository(client: client);

        expect(
          () => repo.fetchCakes(),
          throwsA(
            isA<CakeFetchException>().having(
              (e) => e.message,
              'message',
              startsWith('Malformed response'),
            ),
          ),
        );
      });

      test('throws CakeFetchException on SocketException', () async {
        final client = MockClient(
            (_) async => throw const SocketException('No route to host'));

        final repo = CakeRepository(client: client);

        expect(
          () => repo.fetchCakes(),
          throwsA(
            isA<CakeFetchException>().having(
              (e) => e.message,
              'message',
              startsWith('No internet connection'),
            ),
          ),
        );
      });

      test('CakeFetchException.toString includes the message', () {
        const ex = CakeFetchException('something went wrong');
        expect(ex.toString(), contains('something went wrong'));
      });
    });
  });
}
