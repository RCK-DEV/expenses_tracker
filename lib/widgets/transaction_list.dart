import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function(String) _removeTransactionHandler;

  TransactionList(this._transactions, this._removeTransactionHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // TODO: Calculate dynamically
      child: _transactions.isEmpty
          ? Column(
              children: [
                Text('No transactions added yet.',
                    style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 20),
                Container(
                    height: 200,
                    child: Image.asset('assets/images/waiting.png',
                        fit: BoxFit.cover))
              ],
            )
          : ListView.builder(
              itemBuilder: buildListItem,
              itemCount: _transactions.length,
            ),
    );
  }

  Widget buildListItem(BuildContext ctx, int index) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
            radius: 30,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                    child: Text('\$${_transactions[index].amount}')))),
        title: Text(
          _transactions[index].title,
          style: Theme.of(ctx).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat().format(_transactions[index].date),
          style: TextStyle(color: Colors.blueGrey),
        ),
        trailing: IconButton(
            color: Theme.of(ctx).errorColor,
            onPressed: () {
              _removeTransactionHandler(_transactions[index].id);
            },
            icon: Icon(Icons.delete)),
      ),
    );
  }
}
