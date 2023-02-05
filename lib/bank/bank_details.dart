class BankDetails {

  BankType bank;

  String branch;

  BankAccountType accountType;

  String accountNumber;

  BankDetails(this.bank, this.branch, this.accountType, this.accountNumber);

}

enum BankType { absa, fnb, nedbank, standardBank, discovery }

enum BankAccountType { cheque, savings }