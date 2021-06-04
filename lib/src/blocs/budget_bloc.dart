import 'dart:async';
import 'package:budget_tracker/src/models/item_model.dart';
import 'package:rxdart/rxdart.dart';
import '../repositories/budget_repository.dart';

class BudgetBloc {
  final _repository = BudgetRepository();
  final _itemsOutput = BehaviorSubject<List<ItemModel>>();

  // Streams getters
  Stream<List<ItemModel>> get items => _itemsOutput.stream;

  fetchItems() async {
    _itemsOutput.add(await _repository.getItems());
  }

  dispose() {
    _itemsOutput.close();
  }
}
