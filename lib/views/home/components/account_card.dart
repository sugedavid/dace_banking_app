import 'package:banking_app/models/account.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class AccountCard extends StatelessWidget {
  const AccountCard({super.key, required this.accountData});

  final AccountModel accountData;

  @override
  Widget build(BuildContext context) {
    final accountType = accountData.accountType;
    final accountNumber = accountData.accountNumber;
    final amount = accountData.amount;

    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text(
            '$accountType Account',
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            accountNumber,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Text(
            '£ $amount',
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ));
  }
}
