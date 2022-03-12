import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class NewTransaction extends StatefulWidget {
  final Function(String, double, DateTime) addTransactionHandler;

  NewTransaction(this.addTransactionHandler);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              left: 10, right: 10, top: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                  onSubmitted: (_) => submitData(),
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title')),
              TextField(
                  onSubmitted: (_) => submitData(),
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Amount')),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No data chosen!'
                          : 'Selected date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButton(
                        'Choose date', buttonPressedHandler, buttonPressedCupertinoHandler)
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () => submitData(),
                child: Text(
                  'Add transaction',
                ),
                textColor: Theme.of(context).textTheme.button.color,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitData() {
    if (amountController.text.isEmpty || double.tryParse(amountController.text) == null) return;

    final String enteredTitle = titleController.text;
    final double enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) return;

    widget.addTransactionHandler(
        titleController.text, double.parse(amountController.text), _selectedDate);

    Navigator.of(context).pop();
  }

  buttonPressedCupertinoHandler() {
    bool onDateTimeChangedExecuted = false;

    var cupertinoDatePicker = CupertinoDatePicker(
        initialDateTime: DateTime.now(),
        onDateTimeChanged: (pickedDate) {
          onDateTimeChangedExecuted = true;
          if (pickedDate == null) return;
          setState(() => _selectedDate = pickedDate);
        });

    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            // The Bottom margin is provided to align the popup above the system navigation bar.
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // Provide a background color for the popup.
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(
              top: false,
              child: cupertinoDatePicker,
            ),
          );
        });

    if (!onDateTimeChangedExecuted) {
      setState(() => _selectedDate = cupertinoDatePicker.initialDateTime);
    }
  }

  void buttonPressedHandler() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() => _selectedDate = pickedDate);
    });
  }
}
