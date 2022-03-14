import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    Key key,
    @required Transaction transaction,
    @required Function(String p1) removeTransactionHandler,
  })  : _transaction = transaction,
        _removeTransactionHandler = removeTransactionHandler,
        super(key: key);

  final Transaction _transaction;
  final Function(String p1) _removeTransactionHandler;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
            radius: 30,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(child: Text('\$${_transaction.amount}')))),
        title: Text(
          _transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat().format(_transaction.date),
          style: TextStyle(color: Colors.blueGrey),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                label: Text('delete'),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => _removeTransactionHandler(_transaction.id),
              )
            : IconButton(
                color: Theme.of(context).errorColor,
                onPressed: () => _removeTransactionHandler(_transaction.id),
                icon: Icon(Icons.delete)),
      ),
    );
  }
}
