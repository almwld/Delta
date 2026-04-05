import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محفظتي'),
        backgroundColor: const Color(0xFFD4AF37),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 80, color: Color(0xFFD4AF37)),
            SizedBox(height: 16),
            Text('محفظة فلكس', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('سيتم إضافة الميزات قريباً', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
