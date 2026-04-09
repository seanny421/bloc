import 'package:cake_it_app/src/features/cake/data/cake.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cake', () {
    group('fromJson', () {
      test('parses all fields correctly', () {
        final json = {
          'title': 'Lemon Drizzle',
          'desc': 'A zesty classic',
          'image': 'https://example.com/lemon.jpg',
        };

        final cake = Cake.fromJson(json);

        expect(cake.title, 'Lemon Drizzle');
        expect(cake.description, 'A zesty classic');
        expect(cake.image, 'https://example.com/lemon.jpg');
      });

      test('falls back to empty strings when fields are null', () {
        final cake =
            Cake.fromJson({'title': null, 'desc': null, 'image': null});

        expect(cake.title, '');
        expect(cake.description, '');
        expect(cake.image, '');
      });

      test('falls back to empty strings when fields are absent', () {
        final cake = Cake.fromJson({});

        expect(cake.title, '');
        expect(cake.description, '');
        expect(cake.image, '');
      });
    });

    group('toJson', () {
      test('serialises all fields correctly', () {
        const cake = Cake(
          title: 'Battenberg',
          description: 'Marzipan wrapped',
          image: 'https://example.com/battenberg.jpg',
        );

        expect(cake.toJson(), {
          'title': 'Battenberg',
          'desc': 'Marzipan wrapped',
          'image': 'https://example.com/battenberg.jpg',
        });
      });
    });

    test('round-trips through toJson → fromJson', () {
      const original = Cake(
        title: 'Victoria Sponge',
        description: 'Classic British cake',
        image: 'https://example.com/victoria.jpg',
      );

      final roundTripped = Cake.fromJson(original.toJson());

      expect(roundTripped.title, original.title);
      expect(roundTripped.description, original.description);
      expect(roundTripped.image, original.image);
    });
  });
}
