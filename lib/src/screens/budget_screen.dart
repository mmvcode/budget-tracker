import 'package:budget_tracker/src/blocs/budget_bloc.dart';
import 'package:budget_tracker/src/blocs/budget_provider.dart';
import 'package:budget_tracker/src/errors/failure.dart';
import 'package:budget_tracker/src/models/item_model.dart';
import 'package:budget_tracker/src/widgets/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:budget_tracker/src/widgets/refresh.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends StatefulWidget {
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(context) {
    final bloc = BudgetProvider.of(context);
    bloc.fetchItems();
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Tracker'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(BudgetBloc bloc) {
    return StreamBuilder(
        stream: bloc.items,
        builder: (context, AsyncSnapshot<List<ItemModel>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            final failure = snapshot.error as Failure;
            return Center(
              child: Text(failure.message),
            );
          } else {
            final items = snapshot.data!;
            return Refresh(
              child: ListView.builder(
                itemCount: items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SpendingChart(items: items);
                  }

                  final item = items[index - 1];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        width: 2.0,
                        color: getCategoryColor(item.category),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(item.category),
                      subtitle: Text(
                          '${item.category} - ${DateFormat.yMd().format(item.date)}'),
                      trailing: Text(
                        '-\$${item.price.toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
              ),
            );
          }
        });
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.green[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportation':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}
