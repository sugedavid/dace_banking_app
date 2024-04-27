import 'package:banking_app/models/recipient.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:flutter/material.dart';

import '../../models/transaction.dart';
import '../../shared/ba_divider.dart';
import '../../utils/date.dart';
import '../../utils/firebase_utils/user_utils.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage(
      {super.key, required this.transaction, required this.user});

  final TransactionModel transaction;
  final UserModel user;

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  UserModel senderData = UserModel.toEmpty();
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    if (widget.transaction.transactionType == 'Transfer' &&
        widget.transaction.recipient != null) {
      senderData = await getUserById(widget.transaction.userId, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionAmount = widget.transaction.transactionType == 'Deposit' ||
            (widget.transaction.transactionType == 'Transfer' &&
                widget.transaction.recipient?.userId == widget.user.userId)
        ? '+£${widget.transaction.amount}'
        : '-£${widget.transaction.amount}';
    final transactionType = widget.transaction.transactionType;
    final recipientName =
        '${widget.transaction.recipient?.firstName} ${widget.transaction.recipient?.lastName}';
    final senderName = '${senderData.firstName} ${senderData.lastName}';

    return SinglePageScaffold(
      title: 'Transaction Info',
      child: Column(
        children: [
          // amount
          Text(
            transactionAmount,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: widget.transaction.transactionType == 'Deposit' ||
                        (widget.transaction.transactionType == 'Transfer' &&
                            widget.transaction.recipient?.userId ==
                                widget.user.userId)
                    ? Colors.green
                    : Colors.redAccent),
          ),
          AppSpacing.medium,

          // type
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Transaction Type',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              transactionType,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // status
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Transaction Status',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              widget.transaction.transactionStatus,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // time
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Transaction Time',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              formatDateString(widget.transaction.createdAt),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // ref
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Transaction Ref.',
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Text(
              widget.transaction.transactionRef,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),

          // desc
          if (widget.transaction.transactionDescription != null &&
              widget.transaction.transactionDescription!.isNotEmpty)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Transaction Description',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                widget.transaction.transactionDescription ?? '',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),

          if (widget.transaction.recipient != null &&
              widget.transaction.recipient?.accountId !=
                  RecipientModel.toEmpty().accountId) ...{
            AppSpacing.medium,
            const BADivider(),
            AppSpacing.large,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                (widget.transaction.transactionType == 'Transfer' &&
                        widget.transaction.recipient?.userId ==
                            widget.user.userId)
                    ? 'From'
                    : 'Recipient',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            // ignore: equal_elements_in_set
            AppSpacing.xLarge,

            //  name
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Name',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                (widget.transaction.transactionType == 'Transfer' &&
                        widget.transaction.recipient?.userId ==
                            widget.user.userId)
                    ? senderName
                    : recipientName,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),

            // account
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Account No.',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                (widget.transaction.transactionType == 'Transfer' &&
                        widget.transaction.recipient?.userId ==
                            widget.user.userId)
                    ? widget.transaction.accountNumber
                    : widget.transaction.recipient?.accountNumber ?? '',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),

            // bank
            const ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Bank',
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
              trailing: Text(
                'DACE',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
          }
        ],
      ),
    );
  }
}
