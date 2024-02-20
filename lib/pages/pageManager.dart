import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/adminPage.dart';
import 'package:vbs_sos/pages/employeePage.dart';
import 'package:vbs_sos/pages/profilPage.dart';
import 'package:vbs_sos/pages/seetingsPage.dart';

class PageManager extends StatefulWidget {
  final Employee? employee;
  const PageManager({super.key, this.employee});

  @override
  State<PageManager> createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  int selectedPos = 1;
  late CircularBottomNavigationController _navigationController;
  List<TabItem> tabItems = List.of([
    TabItem(Icons.settings, "Paramètres", kPrimaryColor,
        labelStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: kWhite)),
    TabItem(Icons.home, "Accueil", kPrimaryColor,
        labelStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: kWhite)),
    TabItem(Icons.person, "Profil", kPrimaryColor,
        labelStyle: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 13, color: kWhite)),
  ]);

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(selectedPos);
    checkPermission();
  }

  void checkPermission() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: bodyContainer(),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget bodyContainer() {
    Widget page;
    switch (selectedPos) {
      case 0:
        page = const SettingsPage();
        break;
      case 1:
        page = widget.employee!.role == "ADMIN"
            ? AdminPage(
                employee: widget.employee!,
              )
            : EmployeePage(
                employee: widget.employee,
              );
        break;
      case 2:
        page = ProfilPage(
          employee: widget.employee!,
        );
        break;

      default:
        page = Container();
        break;
    }

    return GestureDetector(
      child: page,
      onTap: () {},
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      selectedPos: selectedPos,
      barHeight: 60,
      barBackgroundColor: kSecondaryColor,
      backgroundBoxShadow: const <BoxShadow>[
        BoxShadow(color: Colors.black45, blurRadius: 10.0),
      ],
      animationDuration: const Duration(milliseconds: 300),
      selectedCallback: (int? selectedPos) {
        setState(() {
          this.selectedPos = selectedPos ?? 0;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}
