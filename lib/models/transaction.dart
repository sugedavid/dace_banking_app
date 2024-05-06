import 'package:banking_app/models/recipient.dart';

class TransactionModel {
  final String transactionId;
  final String transactionType;
  final String transactionStatus;
  final String? transactionDescription;
  final String transactionRef;
  final String userId;
  final String accountId;
  final String accountNumber;
  final RecipientModel? recipient;
  final String? recurring;
  final String createdAt;
  final String amount;

  TransactionModel({
    required this.transactionId,
    required this.transactionType,
    required this.transactionStatus,
    this.transactionDescription,
    required this.transactionRef,
    required this.userId,
    required this.accountId,
    required this.accountNumber,
    this.recipient,
    this.recurring,
    required this.createdAt,
    required this.amount,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    RecipientModel recipient = RecipientModel.toEmpty();
    if (data['recipient'] != null) {
      recipient = RecipientModel.fromMap(data['recipient']);
    }
    return TransactionModel(
      transactionId: data['transactionId'] ?? '',
      transactionType: data['transactionType'] ?? '',
      transactionStatus: data['transactionStatus'] ?? '',
      transactionDescription: data['transactionDescription'] ?? '',
      transactionRef: data['transactionRef'] ?? '',
      userId: data['userId'] ?? '',
      accountId: data['accountId'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      recipient: recipient,
      recurring: data['recurring'] ?? '',
      createdAt: data['createdAt'] ?? '',
      amount: data['amount'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'transactionType': transactionType,
      'transactionStatus': transactionStatus,
      'transactionDescription': transactionDescription,
      'transactionRef': transactionRef,
      'userId': userId,
      'accountId': accountId,
      'accountNumber': accountNumber,
      'recipient': recipient?.toMap(),
      'recurring': recurring,
      'createdAt': createdAt,
      'amount': amount,
    };
  }

  // empty transaction
  static TransactionModel toEmpty() {
    return TransactionModel(
      transactionId: '',
      transactionType: '',
      transactionStatus: '',
      transactionDescription: '',
      transactionRef: '',
      userId: '',
      accountId: '',
      accountNumber: '',
      recipient: RecipientModel.toEmpty(),
      recurring: '',
      createdAt: '',
      amount: '',
    );
  }
}
