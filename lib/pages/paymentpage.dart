import 'package:flutter/material.dart';

void main() => runApp(PaymentApp());

class PaymentApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PaymentPage(amountToPay: 10.0),
    );
  }
}

class PaymentPage extends StatelessWidget {
  final double amountToPay; // Parameter for amount
  final double serviceCharge = 5.0; // Fixed Service Charge
  final double discount = 3.0; // Fixed Discount

  PaymentPage({required this.amountToPay}); // Constructor

  @override
  Widget build(BuildContext context) {
    final double totalAmount = amountToPay + serviceCharge - discount;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade200],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow("Amount", "₹$amountToPay"),
                  SizedBox(height: 8),
                  Divider(color: Colors.white54),
                  SizedBox(height: 8),
                  _buildSummaryRow("Service Charges", "₹$serviceCharge"),
                  SizedBox(height: 8),
                  _buildSummaryRow("Discount", "- ₹$discount"),
                  SizedBox(height: 8),
                  Divider(color: Colors.white54),
                  SizedBox(height: 8),
                  _buildSummaryRow("Total", "₹$totalAmount", isBold: true),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  "Secure Payment",
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _showPaymentOptions(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 110),
                  shadowColor: Colors.deepPurple.withOpacity(0.4),
                  elevation: 10,
                ),
                child: Text(
                  "Proceed to Pay",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showPaymentOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Choose Payment Method",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              SizedBox(height: 16),
              PaymentMethodButton(
                icon: Icons.credit_card,
                label: "Credit/Debit Card",
                onTap: () {
                  Navigator.pop(context);
                  _processPayment("Credit/Debit Card");
                },
              ),
              PaymentMethodButton(
                icon: Icons.account_balance_wallet,
                label: "UPI",
                onTap: () {
                  Navigator.pop(context);
                  _processPayment("UPI");
                },
              ),
              PaymentMethodButton(
                icon: Icons.account_balance,
                label: "Net Banking",
                onTap: () {
                  Navigator.pop(context);
                  _processPayment("Net Banking");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processPayment(String method) {
    // Implement your payment processing logic here
    print("Proceeding with $method payment of ₹$amountToPay");
  }
}

class PaymentMethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PaymentMethodButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepPurple, size: 28),
            SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(fontSize: 18, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }
}