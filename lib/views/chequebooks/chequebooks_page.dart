import 'package:banking_app/models/account.dart';
import 'package:banking_app/models/chequebook.dart';
import 'package:banking_app/models/user.dart';
import 'package:banking_app/shared/ba_divider.dart';
import 'package:banking_app/shared/single_page_scaffold.dart';
import 'package:banking_app/utils/date.dart';
import 'package:banking_app/utils/firebase_utils/chequebook_utils.dart';
import 'package:banking_app/utils/spacing.dart';
import 'package:banking_app/views/chequebooks/request_chequebook_page.dart';
import 'package:flutter/material.dart';

class CheckBooksPage extends StatefulWidget {
  const CheckBooksPage({
    super.key,
    required this.userData,
    required this.currentAccount,
    required this.bankAccounts,
  });

  final UserModel userData;
  final AccountModel currentAccount;
  final List<AccountModel> bankAccounts;

  @override
  State<CheckBooksPage> createState() => _CheckBooksPageState();
}

class _CheckBooksPageState extends State<CheckBooksPage> {
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: 'Chequebooks',
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder: (context) => RequestCheckBook(
                    userData: widget.userData,
                    currentAccount: widget.currentAccount,
                    bankAccounts: widget.bankAccounts,
                  ),
                ),
              )
              .then((value) => setState(() {})),
          label: const Text('Request'),
          icon: const Icon(Icons.add)),
      child: FutureBuilder(
          future: fetchChequeBooks(
              userId: widget.userData.userId,
              accountId: widget.currentAccount.accountId,
              context: context),
          builder: (context, snapshot) {
            // loading state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            // error state
            else if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching chequebooks: ${snapshot.error}'),
              );
            }
            // success state
            else {
              List<ChequeBookModel> chequeBooks =
                  snapshot.data as List<ChequeBookModel>;
              chequeBooks = chequeBooks.reversed.toList();
              return chequeBooks.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple.withOpacity(0.1),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: const Icon(
                              Icons.book_outlined,
                              size: 38.0,
                              color: Colors.purple,
                            ),
                          ),
                          AppSpacing.small,
                          const Text(
                            'Chequebooks',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Your requested chequebooks will appear here.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) => const BADivider(),
                        itemCount: chequeBooks.length,
                        itemBuilder: (context, index) {
                          final chequeBook =
                              snapshot.data?[index] as ChequeBookModel;

                          return ListTile(
                            title: Text(
                              '${chequeBook.title} ${widget.userData.firstName} ${widget.userData.lastName}',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              formatDateString(chequeBook.createdAt),
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  chequeBook.address,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  chequeBook.postCode,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
            }
          }),
    );
  }
}
