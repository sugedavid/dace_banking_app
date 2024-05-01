import 'package:banking_app/models/account.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class AccountCard extends StatelessWidget {
  const AccountCard(
      {super.key, required this.accountData, required this.isLoading});

  final AccountModel accountData;
  final bool isLoading;

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
          isThreeLine: false,
          dense: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$accountType Account',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                ActionChip(
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.8),
                  side: BorderSide.none,
                  onPressed: () {},
                  label: Text(
                    accountNumber,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: isLoading
              ? SizedBox(
                  width: 20,
                  child: LinearProgressIndicator(
                    color: AppColors.accentColor.withOpacity(0.1),
                  ),
                )
              : Text(
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
