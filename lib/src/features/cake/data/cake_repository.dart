import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'cake.dart';

class CakeFetchException implements Exception {
  const CakeFetchException(this.message);
  final String message;

  @override
  String toString() => 'CakeFetchException: $message';
}

class CakeRepository {
  CakeRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static final Uri _cakesUrl = Uri.parse(
    'https://gist.githubusercontent.com/hart88/'
    '79a65d27f52cbb74db7df1d200c4212b/raw/'
    'ebf57198c7490e42581508f4f40da88b16d784ba/cakeList',
  );

  Future<List<Cake>> fetchCakes() async {
    try {
      final response = await _client.get(_cakesUrl);

      if (response.statusCode != 200) {
        throw CakeFetchException(
          'Unexpected status code: ${response.statusCode}',
        );
      }

      final List<dynamic> decoded = json.decode(response.body) as List<dynamic>;
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(Cake.fromJson)
          .toList();
    } on CakeFetchException {
      rethrow;
    } on SocketException catch (e) {
      throw CakeFetchException('No internet connection: ${e.message}');
    } on FormatException catch (e) {
      throw CakeFetchException('Malformed response: ${e.message}');
    } catch (e) {
      throw CakeFetchException('Unexpected error: $e');
    }
  }
}
