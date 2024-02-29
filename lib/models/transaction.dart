class TransactionModel {
  final String transactionId;
  final String transactionType;
  final String transactionStatus;
  final String? transactionDescription;
  final String userId;
  final String accountId;
  final String accountNumber;
  final String createdAt;
  final String amount;

  TransactionModel({
    required this.transactionId,
    required this.transactionType,
    required this.transactionStatus,
    this.transactionDescription,
    required this.userId,
    required this.accountId,
    required this.accountNumber,
    required this.createdAt,
    required this.amount,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> data) {
    return TransactionModel(
      transactionId: data['transactionId'] ?? '',
      transactionType: data['transactionType'] ?? '',
      transactionStatus: data['transactionStatus'] ?? '',
      transactionDescription: data['transactionDescription'] ?? '',
      userId: data['userId'] ?? '',
      accountId: data['accountId'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
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
      'userId': userId,
      'accountId': accountId,
      'accountNumber': accountNumber,
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
      userId: '',
      accountId: '',
      accountNumber: '',
      createdAt: '',
      amount: '',
    );
  }
}
