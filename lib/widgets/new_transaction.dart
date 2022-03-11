import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(25),
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
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now())
                          .then((pickedDate) {
                        if (pickedDate == null) return;
                        setState(() => _selectedDate = pickedDate);
                      });
                    },
                  )
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
    );
  }

  void submitData() {
    if (amountController.text.isEmpty ||
        double.tryParse(amountController.text) == null) return;

    final String enteredTitle = titleController.text;
    final double enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null)
      return;

    widget.addTransactionHandler(titleController.text,
        double.parse(amountController.text), _selectedDate);

    Navigator.of(context).pop();
  }
}
