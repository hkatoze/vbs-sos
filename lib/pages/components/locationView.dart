import 'package:flutter/material.dart';

import 'package:vbs_sos/constants.dart';

import 'package:webview_flutter/webview_flutter.dart';

class LocationWebview extends StatefulWidget {
  final String employeeName;
  final String link;
  const LocationWebview(
      {super.key, required this.employeeName, required this.link});

  @override
  State<LocationWebview> createState() => _LocationWebviewState();
}

class _LocationWebviewState extends State<LocationWebview> {
  late WebViewController controller;
  String _url = 'https://www.example.com';
  bool _isLoading = true;
  void initState() {
    super.initState();
    setState(() {
      _url = widget.link;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              width: 60,
              height: 50,
              child: Icon(
                Icons.close,
                size: 35,
                color: kPrimaryColor,
              ),
            ),
          )
        ],
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.only(left: 30.0),
          child: Text(
            "Emplacement : ${widget.employeeName}",
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: kSecondaryColor,
        iconTheme: IconThemeData(
          color: kWhite,
        ),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: _url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controller = webViewController;
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {},
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: kSecondaryColor,
              ),
            ),
        ],
      ),
    );
  }
}

void showLocationModal(BuildContext context, String employeeName, String link) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          LocationWebview(employeeName: employeeName, link: link));
}
