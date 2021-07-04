import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sound4u/paydetail.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Pay extends StatefulWidget {
  final Detail detail;

  const Pay({Key key, this.detail}) : super(key: key);

  @override
  _PayState createState() => _PayState();
}

class _PayState extends State<Pay> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Payment'),
          ),
          body: Center(
            child: Container(
              child: Column(
                children: [
                  Expanded(
                    child: WebView(
                      initialUrl:
                          'http://crimsonwebs.com/s274004/sound4u/php/bill.php?email=' +
                              widget.detail.email +
                              '&name=' +
                              widget.detail.name +
                              '&amount=' +
                              widget.detail.amount,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
