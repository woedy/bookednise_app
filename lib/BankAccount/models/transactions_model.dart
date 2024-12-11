class TransactionsModel {
  String? message;
  Data? data;

  TransactionsModel({this.message, this.data});

  TransactionsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? balance;
  List<Transactions>? transactions;
  Pagination? pagination;

  Data({this.balance, this.transactions, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['balance'] = this.balance;
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
  Null? next;
  Null? previous;

  Pagination({this.pageNumber, this.totalPages, this.next, this.previous});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNumber = json['page_number'];
    totalPages = json['total_pages'];
    next = json['next'];
    previous = json['previous'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_number'] = this.pageNumber;
    data['total_pages'] = this.totalPages;
    data['next'] = this.next;
    data['previous'] = this.previous;
    return data;
  }
}
