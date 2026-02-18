import "dart:io";

class ATM {
  late int _pin;
  double _balance = 0.0; 

  // Setter to set PIN
  set pinSet(int pin) {
    _pin = pin;
    print("Your ATM PIN was set successfully.");
  }

  // Getter for balance
  double get balance => _balance;

  // Deposit method
  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print("Successfully deposited \$${amount}. Current balance: \$$_balance");
    } else {
      print("Enter a valid amount.");
    }
  }

  // Withdraw method
  void withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print("Successfully withdrew \$${amount}. Current balance: \$$_balance");
    } else {
      print(
          "Invalid withdrawal amount. Your balance is \$$_balance");
    }
  }
}

void main() {
  ATM atm = ATM();

  // Set PIN
  print("Enter your PIN:");
  int pin = int.parse(stdin.readLineSync()!);
  atm.pinSet = pin;

  int option = 0;
  do {
    print("\nSelect an option:");
    print("1. Deposit");
    print("2. Check Balance");
    print("3. Withdraw");
    print("4. Exit");

    option = int.parse(stdin.readLineSync()!);

    switch (option) {
      case 1:
        print("Enter amount to deposit:");
        double amount = double.parse(stdin.readLineSync()!);
        atm.deposit(amount);
        break;

      case 2:
        print("Your balance is \$${atm.balance}");
        break;

      case 3:
        print("Enter amount to withdraw:");
        double amount = double.parse(stdin.readLineSync()!);
        atm.withdraw(amount);
        break;

      case 4:
        print("Thank you for using the ATM. Goodbye!");
        break;

      default:
        print("Invalid option. Try again.");
    }
  } while (option != 4);
}
