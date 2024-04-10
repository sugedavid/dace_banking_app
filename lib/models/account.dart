class AccountModel {
  final String accountId;
  final String accountNumber;
  final String createdAt;
  final String updatedAt;
  final String amount;
  final String accountType;

  AccountModel({
    required this.accountId,
    required this.accountNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.amount,
    required this.accountType,
  });

  factory AccountModel.fromMap(Map<String, dynamic> data) {
    return AccountModel(
      accountId: data['accountId'] ?? '',
      accountNumber: data['accountNumber'] ?? '',
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      amount: data['amount'] ?? '0',
      accountType: data['accountType'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'accountNumber': accountNumber,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'amount': amount,
      'accountType': accountType,
    };
  }

  // empty account
  static AccountModel toEmpty() {
    return AccountModel(
      accountId: '',
      accountNumber: '',
      createdAt: '',
      updatedAt: '',
      amount: '',
      accountType: '',
    );
  }
}
