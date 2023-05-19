import 'package:charity_app/home.dart';
import 'package:flutter/material.dart';

class ThankYouPage extends StatelessWidget {
  final String message;

  ThankYouPage(this.message);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thank You'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 16),
            Text(
              'Thank you for your payment!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
