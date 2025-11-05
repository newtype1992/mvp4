class PayService {
  Future<void> simulatePayment({required double amount}) async {
    await Future<void>.delayed(const Duration(seconds: 2));
  }
}
