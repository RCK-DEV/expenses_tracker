import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter_complete_guide/models/transaction.dart';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal expenses',
      home: MyHomePage(),
      theme: ThemeData(
          fontFamily: 'Quicksand',
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(button: TextStyle(color: Colors.white))),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
        title: 'Shoes', amount: 69.99, id: 't1', date: DateTime.now().subtract(Duration(days: 1))),
    Transaction(
        title: 'Groceries',
        amount: 29.99,
        id: 't2',
        date: DateTime.now().subtract(Duration(days: 2))),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (transaction) => transaction.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    final Text appBarTitleWidget = Text('Personal expenses');

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: appBarTitleWidget,
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () => _startAddNewTransaction(context),
                child: Icon(CupertinoIcons.add),
              )
            ]),
          )
        : AppBar(
            title: appBarTitleWidget,
            actions: [
              IconButton(onPressed: () => _startAddNewTransaction(context), icon: Icon(Icons.add))
            ],
          );

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final deviceHeight =
        mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;

    final txListWidget = Container(
        height: deviceHeight * .7, child: TransactionList(_userTransactions, _deleteTransaction));

    final txChartWidgetPortraitHeight = .3;
    final txChartWidgetLandscapeHeight = .7;

    final txChartWidget = Container(
        height: deviceHeight *
            (isLandscape ? txChartWidgetLandscapeHeight : txChartWidgetPortraitHeight),
        child: Chart(_recentTransactions));

    final txSwitchWidget = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show chart',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _showChart,
            onChanged: (switchState) {
              setState(() {
                _showChart = switchState;
              });
            }),
      ],
    );

    var scaffoldBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        children: [
          if (isLandscape) ...[
            txSwitchWidget,
            _showChart ? txChartWidget : txListWidget
          ] else ...[
            txChartWidget,
            txListWidget
          ],
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: scaffoldBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: scaffoldBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context), child: Icon(Icons.add)),
          );
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTx =
        Transaction(id: DateTime.now().toString(), title: title, amount: amount, date: date);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }
}
