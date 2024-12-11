class BankAccountModel {
  String? message;
  Data? data;

  BankAccountModel({this.message, this.data});

  BankAccountModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  double? balance;
  String? accountId;
  List<Transactions>? transactions;
  Pagination? pagination;

  Data({this.balance, this.accountId, this.transactions, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    balance = json['balance']?.toDouble();
    accountId = json['account_id'];
    if (json['transactions'] != null) {
      transactions = [];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['balance'] = this.balance;
    data['account_id'] = this.accountId;
    if (this.transactions != null) {
      data['transactions'] =
          this.transactions!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Transactions {
  int? id;
  String? transactionId;
  String? transactionType;
  String? amount;
  String? timestamp;
  String? description;
  int? bankAccount;

  Transactions(
      {this.id,
        this.transactionId,
        this.transactionType,
        this.amount,
        this.timestamp,
        this.description,
        this.bankAccount});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    timestamp = json['timestamp'];
    description = json['description'];
    bankAccount = json['bank_account'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['transaction_type'] = this.transactionType;
    data['amount'] = this.amount;
    data['timestamp'] = this.timestamp;
    data['description'] = this.description;
    data['bank_account'] = this.bankAccount;
    return data;
  }
}

class Pagination {
  int? pageNumber;
  int? totalPages;
  int? next;
  int? previous;

  Pagination({this.pageNumber, this.totalPages, this.next, this.previous});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNumber = json['page_number'];
    totalPages = json['total_pages'];
    next = json['next'];
    previous = json['previous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page_number'] = this.pageNumber;
    data['total_pages'] = this.totalPages;
    data['next'] = this.next;
    data['previous'] = this.previous;
    return data;
  }
}
