import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function(String) _removeTransactionHandler;

  TransactionList(this._transactions, this._removeTransactionHandler);

  @override
  Widget build(BuildContext context) {
    return _transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text('No transactions added yet.', style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 20),
                Container(
                    height: constraints.maxHeight * .6,
                    child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover))
              ],
            );
          })
        : ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) {},
            itemBuilder: buildListItem,
            itemCount: _transactions.length,
          );
  }

  Widget buildListItem(BuildContext ctx, int index) {
    return TransactionListItem(
        key: ValueKey(_transactions[index].id),
        transaction: _transactions[index],
        removeTransactionHandler: _removeTransactionHandler);
  }
}
