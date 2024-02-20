import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/notificationsPage.dart';
import 'package:vbs_sos/pages/pageManager.dart';

AppBar MyAppBar(GlobalKey<ScaffoldState> scaffoldKey, BuildContext context,
    Employee employee) {
  return AppBar(
    leading: GestureDetector(
        onTap: () {
          scaffoldKey.currentState!.openDrawer();
        },
        child: SizedBox(
            width: 80,
            height: 50,
            child: Icon(
              Icons.menu,
              size: 35,
              color: kWhite,
            ))),
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeftJoined,
                  child: NotificationsPage(
                    employee: employee,
                  ),
                  childCurrent: PageManager(
                    employee: employee,
                  )));
        },
        child: SizedBox(
          width: 60,
          height: 50,
          child: Icon(
            Bootstrap.bell,
            size: 35,
            color: kWhite,
          ),
        ),
      )
    ],
    centerTitle: true,
    title: Container(
      padding: const EdgeInsets.only(left: 30.0),
      child: const Text(
        'VBS-SOS',
        style: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    backgroundColor: kSecondaryColor,
    iconTheme: IconThemeData(
      color: kWhite,
    ),
  );
}
