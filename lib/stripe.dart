import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:charity_app/thankyou.dart';
import 'package:charity_app/home.dart';
import 'dart:io';

class StripeWidget extends StatefulWidget {
  @override
  _StripeWidgetState createState() => _StripeWidgetState();
}

class _StripeWidgetState extends State<StripeWidget> {
  _StripeWidgetState();
  String selectedUrl = '';
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    selectedUrl = 'https://mydonations.org/pay.php';

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          title: Text("Payment",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          bottomOpacity: 1.0,
          elevation: 0.0,
          bottom: PreferredSize(
              child: Container(
                color: Color(0xffe8e8e8),
                height: 1.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                child: Stack(children: [
              WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: selectedUrl,
                gestureNavigationEnabled: true,
                userAgent:
                    'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
                onWebViewCreated: (WebViewController webViewController) {},
                onPageStarted: (String url) {
                  bool _isSuccess = url.contains('order-received');
                  bool _isFailed = url.contains('fail');
                  bool _ispaypal = url.contains('paypal');
                  print('Page started loading: $url');
                  setState(() {
                    _isLoading = true;
                  });
                  if (_isSuccess && !_ispaypal) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => ThankYouPage(
                                  'Thank You for the Payment',
                                )),
                        (route) => false);
                  } else if (_isFailed) {
                    // Put the payment failed widget.
                  }
                },
                onPageFinished: (String url) {
                  bool _isSuccess = url.contains('order-received');
                  bool _isFailed = url.contains('fail');
                  bool _ispaypal = url.contains('paypal');
                  print('Page started loading: $url');
                  setState(() {
                    _isLoading = true;
                  });
                  if (_isSuccess && !_ispaypal) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => ThankYouPage(
                                  'Thank You for the Payment',
                                )),
                        (route) => false);
                  } else if (_isFailed) {
                    // Put the payment failed widget.
                  }
                },
              ),
            ]))
          ],
        ),
      ),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomePage()), (route) => false);
    return Future.value(true);
  }
}
