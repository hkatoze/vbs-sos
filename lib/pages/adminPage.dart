import 'package:accordion/accordion.dart';

import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:latlong2/latlong.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/alertPivot.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/components/accordionListItem.dart';
import 'package:vbs_sos/pages/components/alertFloatingActionButton.dart';

import 'package:vbs_sos/pages/components/myAppBar.dart';
import 'package:vbs_sos/pages/components/myDrawer.dart';
import 'package:vbs_sos/services/firbase_sevices.dart';

class AdminPage extends StatefulWidget {
  final Employee employee;
  const AdminPage({super.key, required this.employee});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool alertGeneral = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: kWhite,
        appBar: MyAppBar(_scaffoldKey, context, widget.employee),
        drawer: MyDrawer(
          employee: widget.employee,
        ),
        floatingActionButton: AlarmFloatingActionButton(
          employee: widget.employee,
          onPressed: () {
            setState(() {
              alertGeneral = !alertGeneral;
            });
          },
        ),
        body: Column(
          children: [
            Expanded(
                child: Stack(
              children: [
                Positioned(
                  child: SizedBox(
                    height: kHeight(context) * 0.8,
                    child: FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(12.35, -1.516667),
                        initialZoom: 16,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Accordion(
                      headerBorderColorOpened: Colors.transparent,
                      contentBackgroundColor: kWhite,
                      contentBorderColor: kPrimaryColor,
                      contentBorderWidth: 1,
                      contentHorizontalPadding: 15,
                      scaleWhenAnimating: true,
                      openAndCloseAnimation: true,
                      headerPadding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                      sectionClosingHapticFeedback: SectionHapticFeedback.light,
                      children: [
                        AccordionSection(
                          isOpen: false,
                          headerBorderRadius: 7,
                          leftIcon:
                              Icon(Bootstrap.geo_alt, color: kWhite, size: 18),
                          header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Employés en danger",
                                  style: TextStyle(
                                      color: kWhite,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                                StreamBuilder<String>(
                                  stream: alertGeneral
                                      ? countAlerts(widget.employee.companyId,
                                          "IN DANGER")
                                      : countNeedHelpAlerts(
                                          widget.employee.companyId,
                                          "IN DANGER"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                        '${snapshot.error}',
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      );
                                    } else {
                                      String alertCount = snapshot.data ?? "";
                                      return Text(
                                        alertCount,
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      );
                                    }
                                  },
                                )
                              ]),
                          headerBackgroundColor: kPrimaryColor,
                          content: SizedBox(
                            height: kHeight(context) * 0.5,
                            child: StreamBuilder<List<AlertPivot>>(
                                stream: alertGeneral
                                    ? streamAlertPivots(
                                        widget.employee.employeeId,
                                        widget.employee.companyId,
                                        "IN DANGER")
                                    : streamNeedHelpAlerts(
                                        widget.employee.companyId, "IN DANGER"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {}

                                  List<AlertPivot> alertPivots =
                                      snapshot.data ?? [];

                                  return alertPivots.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "Aucun employé",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: alertPivots.length,
                                          itemBuilder: (context, index) {
                                            return AccordionListItem(
                                              alert: alertPivots[index],
                                            );
                                          });
                                }),
                          ),
                        ),
                      ],
                    ),
                    Accordion(
                      headerBorderColorOpened: Colors.transparent,
                      contentBackgroundColor: kWhite,
                      contentBorderColor: Colors.green,
                      contentBorderWidth: 1,
                      contentHorizontalPadding: 15,
                      scaleWhenAnimating: true,
                      openAndCloseAnimation: true,
                      headerPadding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                      sectionClosingHapticFeedback: SectionHapticFeedback.light,
                      children: [
                        AccordionSection(
                          isOpen: false,
                          headerBorderRadius: 7,
                          leftIcon:
                              Icon(Bootstrap.geo_alt, color: kWhite, size: 18),
                          header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Employés Hors Danger",
                                  style: TextStyle(
                                      color: kWhite,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                                StreamBuilder<String>(
                                  stream: alertGeneral
                                      ? countAlerts(
                                          widget.employee.companyId, "SAFE")
                                      : countNeedHelpAlerts(
                                          widget.employee.companyId, "SAFE"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                        '${snapshot.error}',
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      );
                                    } else {
                                      String alertCount = snapshot.data ?? "";
                                      return Text(
                                        alertCount,
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      );
                                    }
                                  },
                                )
                              ]),
                          headerBackgroundColor: Colors.green,
                          content: SizedBox(
                            height: kHeight(context) * 0.5,
                            child: StreamBuilder<List<AlertPivot>>(
                                stream: alertGeneral
                                    ? streamAlertPivots(
                                        widget.employee.employeeId,
                                        widget.employee.companyId,
                                        "SAFE")
                                    : streamNeedHelpAlerts(
                                        widget.employee.companyId, "SAFE"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {}

                                  List<AlertPivot> alertPivots =
                                      snapshot.data ?? [];

                                  return alertPivots.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "Aucun employé",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: alertPivots.length,
                                          itemBuilder: (context, index) {
                                            return AccordionListItem(
                                              alert: alertPivots[index],
                                            );
                                          });
                                }),
                          ),
                        ),
                      ],
                    ),
                    Accordion(
                      headerBorderColorOpened: Colors.transparent,
                      contentBackgroundColor: kWhite,
                      contentBorderColor: Colors.grey,
                      contentBorderWidth: 1,
                      contentHorizontalPadding: 15,
                      scaleWhenAnimating: true,
                      openAndCloseAnimation: true,
                      headerPadding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      sectionOpeningHapticFeedback: SectionHapticFeedback.heavy,
                      sectionClosingHapticFeedback: SectionHapticFeedback.light,
                      children: [
                        AccordionSection(
                          isOpen: false,
                          headerBorderRadius: 7,
                          leftIcon:
                              Icon(Bootstrap.geo_alt, color: kWhite, size: 18),
                          header: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Employés Non Repondu",
                                  style: TextStyle(
                                      color: kWhite,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                ),
                                StreamBuilder<String>(
                                  stream: alertGeneral
                                      ? countAlerts(widget.employee.companyId,
                                          "IN PROGRESS")
                                      : countNeedHelpAlerts(
                                          widget.employee.companyId,
                                          "IN PROGRESS"),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                        '${snapshot.error}',
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      );
                                    } else {
                                      String alertCount = snapshot.data ?? "";
                                      return Text(
                                        alertCount,
                                        style: TextStyle(
                                            color: kWhite,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700),
                                      );
                                    }
                                  },
                                )
                              ]),
                          headerBackgroundColor: Colors.grey,
                          content: SizedBox(
                            height: kHeight(context) * 0.5,
                            child: StreamBuilder<List<AlertPivot>>(
                                stream: alertGeneral
                                    ? streamAlertPivots(
                                        widget.employee.employeeId,
                                        widget.employee.companyId,
                                        "IN PROGRESS")
                                    : streamNeedHelpAlerts(
                                        widget.employee.companyId,
                                        "IN PROGRESS"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {}

                                  List<AlertPivot> alertPivots =
                                      snapshot.data ?? [];

                                  return alertPivots.isEmpty
                                      ? const Center(
                                          child: Text(
                                            "Aucun employé",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: alertPivots.length,
                                          itemBuilder: (context, index) {
                                            return AccordionListItem(
                                              alert: alertPivots[index],
                                            );
                                          });
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            )),
          ],
        ));
  }
}
