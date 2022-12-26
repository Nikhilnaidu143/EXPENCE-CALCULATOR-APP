import 'package:expence/models/transaction.dart';
import 'package:expence/widgets/chart_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (i) {
      final weekDay = DateTime.now().subtract(
        Duration(days: i),
      );
      var totalSum = 0.0;
      for (var j = 0; j < recentTransactions.length; j++) {
        if (recentTransactions[j].date.day == weekDay.day &&
            recentTransactions[j].date.month == weekDay.month &&
            recentTransactions[j].date.year == weekDay.year) {
          totalSum += recentTransactions[j].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((e) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  e['day'] as String,
                  e['amount'] as double,
                  totalSpending == 0
                      ? 0
                      : (e['amount'] as double) / totalSpending,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
