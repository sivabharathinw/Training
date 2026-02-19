class Prime {
  void checkPrime(int num) {
    if (num <= 1) {
      print("$num is NOT prime");
      return;
    }

    bool isPrime = true;

    for (int i = 2; i <= num ~/ 2; i++) {
      if (num % i == 0) {
        isPrime = false;
        break;
      }
    }

    if (isPrime) {
      print("$num is PRIME");
    } else {
      print("$num is NOT prime");
    }
  }
}

void main() {
  Prime p = Prime();
  p.checkPrime(10);
  p.checkPrime(5);
  p.checkPrime(11);
}

