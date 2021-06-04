import 'dart:io';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:budget_tracker/src/models/item_model.dart';
import 'package:budget_tracker/src/errors/failure.dart';

class BudgetRepository {
  final _baseUrl = 'https://api.notion.com/v1';
  final Client _client;

  BudgetRepository({Client? client}) : _client = client ?? Client();

  Future<List<ItemModel>> getItems() async {
    try {
      final dbId = dotenv.env['NOTION_DATABASE_ID'];
      final secret = dotenv.env['NOTION_API_KEY'];
      final url = '$_baseUrl/databases/$dbId/query';
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $secret',
          'Notion-Version': '2021-05-13',
        },
      );
      final int statusCode = response.statusCode;

      if (statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['results'] as List)
            .map((e) => ItemModel.fromMap(e))
            .toList()
              ..sort(
                (a, b) => b.date.compareTo(a.date),
              );
      } else {
        throw Failure(message: "Something went wrong ($statusCode)");
      }
    } catch (_) {
      throw const Failure(message: 'Something went wrong 2');
    }
  }

  void dispose() {
    _client.close();
  }
}
