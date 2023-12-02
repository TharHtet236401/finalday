import 'package:flutter/material.dart';
import 'payment.dart';

class Subscription {
  final String title;
  final String monthlyPrice;
  final String description;
  final String duration;
  final List<String> unlockedFeatures;

  Subscription(this.title, this.monthlyPrice, this.description, this.duration,
      this.unlockedFeatures);
}

class SubscriptionPlans extends StatefulWidget {
  @override
  _SubscriptionPlansState createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends State<SubscriptionPlans> {
  final List<Subscription> subscriptions = [
    Subscription("Premium", "15,000 ks", "Exclusive benefits", "1 month",
        ["Feature A", "Feature B", "Feature C"]),
    Subscription("Gold", "12,500 ks", "Premium access", "1 month",
        ["Feature A", "Feature B", "Feature C"]),
    Subscription("Silver", "5,000 ks", "Enchanted Features", "1 month",
        ["Feature A", "Feature B", "Feature C"]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4D4DC6),
        title: const Text('Subscription Plans',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: subscriptions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var subscription in subscriptions)
                        SubscriptionListItem(subscription: subscription),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class SubscriptionListItem extends StatelessWidget {
  final Subscription subscription;

  SubscriptionListItem({required this.subscription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.indigo, width: 1.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subscription.title,
            style: const TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          const Divider(color: Colors.indigo),
          Text(
            'Monthly Cost: ${subscription.monthlyPrice}',
            style: const TextStyle(fontSize: 20.0, color: Colors.black),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Description: ${subscription.description}',
            style: const TextStyle(fontSize: 20.0, color: Colors.black),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Duration: ${subscription.duration}',
            style: const TextStyle(fontSize: 18.0, color: Colors.grey),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Unlocked Features:',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
          ...subscription.unlockedFeatures.map((feature) =>
              Text('- $feature', style: const TextStyle(fontSize: 18.0))),
          const SizedBox(height: 12.0),
          ElevatedButton.icon(
            onPressed: () {
              _handleSubscriptionPurchase(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            label: const Text(
              'Subscribe',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscriptionPurchase(BuildContext context) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.indigo,
          content: Row(
            children: [
              Icon(Icons.payment, color: Colors.white),
              SizedBox(width: 10),
              Text('Processing...', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaymentOptionsScreen(subscription: subscription),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Subscription failed. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
