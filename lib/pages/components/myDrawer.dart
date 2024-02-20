// ignore: file_names
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/functions.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/alertHistoryPage.dart';
import 'package:vbs_sos/pages/employeePage.dart';
import 'package:vbs_sos/pages/myCompanyPage.dart';
import 'package:vbs_sos/pages/notificationsPage.dart';
import 'package:vbs_sos/pages/pageManager.dart';
import 'package:vbs_sos/pages/seetingsPage.dart';

class MyDrawer extends StatelessWidget {
  final Employee employee;
  const MyDrawer({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: kSecondaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              UserAccountsDrawerHeader(
                arrowColor: kPrimaryColor,
                accountName: Text(
                    "${employee.lastname} ${employee.firstname} | ${employee.job}"),
                accountEmail: Text("Tèl: ${employee.phone_number}"),
                currentAccountPicture: CircleAvatar(
                    backgroundColor: kWhite,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(employee.profilUrl))),
                    )),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/android-drawer-bg.jpeg"))),
              ),
              MyList(
                icon: Icons.notifications,
                text: 'Notifications',
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRightJoined,
                          child: NotificationsPage(
                            employee: employee,
                          ),
                          childCurrent: PageManager(
                            employee: employee,
                          )));
                },
              ),
              MyList(
                  icon: Icons.warning,
                  text: 'Historique des alertes',
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRightJoined,
                            child: const AlertHistoryPage(),
                            childCurrent: PageManager(
                              employee: employee,
                            )));
                  }),
              MyList(
                icon: Icons.home,
                text: 'Mon entreprise',
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRightJoined,
                          child: const MyCompanyPage(),
                          childCurrent: PageManager(
                            employee: employee,
                          )));
                },
              ),
              MyList(
                icon: Icons.settings,
                text: 'Paramètres',
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.leftToRightJoined,
                          child: const SettingsPage(),
                          childCurrent: PageManager(
                            employee: employee,
                          )));
                },
              ),
            ],
          ),
          MyList(
              icon: Icons.logout,
              text: 'Déconnexion',
              onTap: () {
                logout(
                    context,
                    EmployeePage(
                      employee: employee,
                    ));
              }),
        ],
      ),
    );
  }
}

class MyList extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const MyList({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        onTap: onTap,
        title: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
