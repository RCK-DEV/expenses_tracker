import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../models/transaction.dart';

class TransactionListItem extends StatefulWidget {
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
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  Color _cardColor;

  // Called before build() so setState() is not required.
  @override
  void initState() {
    super.initState();
    const availableColors = [Colors.red, Colors.blue, Colors.purple, Colors.black];
    _cardColor = availableColors[Random().nextInt(availableColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: _cardColor,
            radius: 30,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(child: Text('\$${widget._transaction.amount}')))),
        title: Text(
          widget._transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat().format(widget._transaction.date),
          style: TextStyle(color: Colors.blueGrey),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                label: Text('delete'),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () => widget._removeTransactionHandler(widget._transaction.id),
              )
            : IconButton(
                color: Theme.of(context).errorColor,
                onPressed: () => widget._removeTransactionHandler(widget._transaction.id),
                icon: Icon(Icons.delete)),
      ),
    );
  }
}
