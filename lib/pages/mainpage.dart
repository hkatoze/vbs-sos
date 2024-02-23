import 'package:flutter/material.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/loginPage.dart';
import 'package:vbs_sos/pages/pageManager.dart';
import 'package:vbs_sos/services/local_db_services.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  String view = "ADMIN";
  bool isConnect = false;
  Employee? employee;

  @override
  void initState() {
    super.initState();
    DatabaseManager.instance.clearDatabase();
    fetchEmployeeInformation();
  }

  void fetchEmployeeInformation() async {
    final Employee? loggedInEmployee =
        await DatabaseManager.instance.getLoggedInEmployee();

    if (loggedInEmployee != null) {
      setState(() {
        isConnect = true;
        view = loggedInEmployee.role;
        employee = loggedInEmployee;
      });
    } else {
      setState(() {
        isConnect = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isConnect
        ? PageManager(
            employee: employee,
          )
        : const LoginPage();
  }
}
