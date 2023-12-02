import 'package:flutter/material.dart';
import 'subscription.dart';

class PaymentOptionsScreen extends StatefulWidget {
  final Subscription subscription;

  PaymentOptionsScreen({required this.subscription});

  @override
  _PaymentOptionsScreenState createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  String selectedPaymentOption = ''; // Track the selected payment option

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Options',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selected Subscription: ${widget.subscription.title}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24.0),
            for (var paymentOption in [
              'KBZPay',
              'WavePay',
              'Yoma Bank',
              'AYA Pay',
              'UAB',
              'CB Pay',
            ])
              RadioListTile(
                title: Text(
                  'Pay with $paymentOption',
                  style: TextStyle(
                    fontSize: 18,
                    color: selectedPaymentOption == paymentOption
                        ? Colors.indigo
                        : null,
                  ),
                ),
                value: paymentOption,
                groupValue: selectedPaymentOption,
                onChanged: (value) {
                  _handlePaymentOptionSelection(value.toString());
                },
                secondary: Image.asset(
                  _getPaymentOptionImage(paymentOption),
                  height: 40.0,
                  width: 40.0,
                ),
              ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                if (selectedPaymentOption.isNotEmpty) {
                  _handlePayButtonPressed(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a payment option.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: Text(
                'Pay with $selectedPaymentOption',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentOptionSelection(String paymentOption) {
    setState(() {
      selectedPaymentOption = paymentOption;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.indigo,
        content: Text('Selected Payment Option: $paymentOption'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handlePayButtonPressed(BuildContext context) {
    // Implement your payment logic here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.indigo,
        content: Text('Processing payment with $selectedPaymentOption...'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _getPaymentOptionImage(String paymentOption) {
    switch (paymentOption) {
      case 'KBZPay':
        return 'images/Kpay.png';
      case 'WavePay':
        return 'images/Wave.png';
      case 'Yoma Bank':
        return 'images/Yoma.png';
      case 'AYA Pay':
        return 'images/AYA.png';
      case 'UAB':
        return 'images/uab.png';
      case 'CB Pay':
        return 'images/CB.png';
      default:
        return '';
    }
  }
}
