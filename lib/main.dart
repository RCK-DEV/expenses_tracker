import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:flutter_complete_guide/models/transaction.dart';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';

void main() => runApp(MyApp());

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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [
    // Transaction(
    //     title: 'Shoes', amount: 69.99, id: 't1', date: DateTime.now().subtract(Duration(days: 1))),
    // Transaction(
    //     title: 'Groceries',
    //     amount: 29.99,
    //     id: 't2',
    //     date: DateTime.now().subtract(Duration(days: 2))),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where(
            (transaction) => transaction.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
        .toList();
  }

  bool _showChart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print('initState MyHomePage Widget');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState MyHomePage Widget');
    print(state);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    print('dispose MyHomePage Widget');
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final Text appBarTitleWidget = Text('Personal expenses');
    PreferredSizeWidget appBar = buildAppBar(appBarTitleWidget, context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final deviceHeight =
        mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top;
    Container txListWidget = buildTxListWidget(deviceHeight);
    final txChartWidgetPortraitHeight = .3;
    final txChartWidgetLandscapeHeight = .7;
    Container txChartWidget = buildTxChartWidget(
        deviceHeight, isLandscape, txChartWidgetLandscapeHeight, txChartWidgetPortraitHeight);
    Row txSwitchWidget = buildTxSwitchWidget(context);
    SafeArea scaffoldBody =
        buildScaffoldBody(isLandscape, txSwitchWidget, txChartWidget, txListWidget);

    return buildScaffold(scaffoldBody, appBar, context);
  }

  StatefulWidget buildScaffold(
      SafeArea scaffoldBody, PreferredSizeWidget appBar, BuildContext context) {
    return Platform.isIOS
        ? buildCupertinoScaffold(scaffoldBody, appBar)
        : buildMaterialScaffold(appBar, scaffoldBody, context);
  }

  Scaffold buildMaterialScaffold(
      PreferredSizeWidget appBar, SafeArea scaffoldBody, BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: scaffoldBody,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _startAddNewTransaction(context), child: Icon(Icons.add)),
    );
  }

  CupertinoPageScaffold buildCupertinoScaffold(SafeArea scaffoldBody, PreferredSizeWidget appBar) {
    return CupertinoPageScaffold(
      child: scaffoldBody,
      navigationBar: appBar,
    );
  }

  SafeArea buildScaffoldBody(
      bool isLandscape, Row txSwitchWidget, Container txChartWidget, Container txListWidget) {
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
    return scaffoldBody;
  }

  Row buildTxSwitchWidget(BuildContext context) {
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
    return txSwitchWidget;
  }

  Container buildTxChartWidget(double deviceHeight, bool isLandscape,
      double txChartWidgetLandscapeHeight, double txChartWidgetPortraitHeight) {
    final txChartWidget = Container(
        height: deviceHeight *
            (isLandscape ? txChartWidgetLandscapeHeight : txChartWidgetPortraitHeight),
        child: Chart(_recentTransactions));
    return txChartWidget;
  }

  Container buildTxListWidget(double deviceHeight) {
    final txListWidget = Container(
        height: deviceHeight * .7, child: TransactionList(_userTransactions, _deleteTransaction));
    return txListWidget;
  }

  PreferredSizeWidget buildAppBar(Text appBarTitleWidget, BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? buildCupertinoNavigationBar(appBarTitleWidget, context)
        : buildMaterialAppBar(appBarTitleWidget, context);
    return appBar;
  }

  AppBar buildMaterialAppBar(Text appBarTitleWidget, BuildContext context) {
    return AppBar(
      title: appBarTitleWidget,
      actions: [
        IconButton(onPressed: () => _startAddNewTransaction(context), icon: Icon(Icons.add))
      ],
    );
  }

  CupertinoNavigationBar buildCupertinoNavigationBar(Text appBarTitleWidget, BuildContext context) {
    return CupertinoNavigationBar(
      middle: appBarTitleWidget,
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          onTap: () => _startAddNewTransaction(context),
          child: Icon(CupertinoIcons.add),
        )
      ]),
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
