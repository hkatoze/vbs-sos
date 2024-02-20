import 'package:flutter/material.dart';

class MyCompanyPage extends StatefulWidget {
  const MyCompanyPage({super.key});

  @override
  State<MyCompanyPage> createState() => _MyCompanyPageState();
}

class _MyCompanyPageState extends State<MyCompanyPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("COMPANY INFORMATIONS PAGE"),
      ),
    );
  }
}
