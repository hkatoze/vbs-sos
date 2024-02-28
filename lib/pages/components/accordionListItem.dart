import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/alertPivot.dart';

import 'package:vbs_sos/pages/components/defaltBtn.dart';
import 'package:vbs_sos/pages/components/locationView.dart';

class AccordionListItem extends StatefulWidget {
  final AlertPivot alert;

  const AccordionListItem({
    super.key,
    required this.alert,
  });

  @override
  State<AccordionListItem> createState() => _AccordionListItemState();
}

class _AccordionListItemState extends State<AccordionListItem> {
  double? lat;
  double? long;

  void localize() {
    showLocationModal(
        context,
        "${widget.alert.employee.lastname} ${widget.alert.employee.firstname}",
        "https://www.google.com/maps/search/?api=1&query=${widget.alert.alert.alertLocation.latitude},${widget.alert.alert.alertLocation.longitude}");
  }

  Future<void> call() async {
    await FlutterPhoneDirectCaller.callNumber(
        widget.alert.employee.phone_number);
  }

  String formaterDate(Timestamp timestamp) {
    DateTime now = DateTime.now();

    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round());

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      DateFormat heureFormat = DateFormat.Hm('fr');
      return heureFormat.format(date);
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Hier à ${DateFormat.Hm('fr').format(date)}';
    } else if (date.year == now.year && date.month == now.month) {
      return '${DateFormat.d('fr').format(date)} ${DateFormat.MMMM('fr').format(date)} à ${DateFormat.Hm('fr').format(date)}';
    } else {
      return '${DateFormat.d('fr').format(date)} ${DateFormat.MMMM('fr').format(date)} ${DateFormat.Hm('fr').format(date)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 237, 237, 237),
          borderRadius: BorderRadius.circular(5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.alert.employee.profilUrl)),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: kSecondaryColor)),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.alert.employee.lastname} ${widget.alert.employee.firstname}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: kSecondaryColor, fontSize: 13),
                      ),
                      Text(
                        widget.alert.employee.job,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: kTextColor, fontSize: 10),
                      ),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 238, 233, 233)),
                child: Text(
                  widget.alert.alert.alertStatus == "IN DANGER"
                      ? "EN DANGER"
                      : (widget.alert.alert.alertStatus == "IN PROGRESS"
                          ? "PAS DE REPONSE"
                          : "HORS DE DANGER"),
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.alert.alert.alertStatus == "IN DANGER"
                        ? Colors.red
                        : (widget.alert.alert.alertStatus == "IN PROGRESS"
                            ? Colors.orange
                            : Colors.green),
                  ),
                ),
              ),
            ]),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formaterDate(widget.alert.alert.alertDatetime),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                    width: 100,
                    height: 30,
                    child: DefaultBtn(
                        event: () => widget.alert.alert.alertStatus ==
                                "IN PROGRESS"
                            ? AwesomeDialog(
                                context: context,
                                animType: AnimType.scale,
                                dialogType: DialogType.info,
                                body: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 1),
                                  child: Column(children: [
                                    Text(
                                      "${widget.alert.employee.lastname} ${widget.alert.employee.firstname} ne peut pas être localiser pour le moment.",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500,
                                          color: kSecondaryColor),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 135,
                                            height: 30,
                                            child: DefaultBtn(
                                                event: () =>
                                                    Navigator.pop(context),
                                                titleSize: 10,
                                                title: "OK",
                                                bgColor: kSecondaryColor)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                  ]),
                                ),
                              ).show()
                            : localize(),
                        titleSize: 10,
                        title: "Localiser",
                        bgColor: widget.alert.alert.alertStatus == "IN PROGRESS"
                            ? Colors.grey
                            : kSecondaryColor)),
                const SizedBox(
                  width: 5,
                ),
                SizedBox(
                    width: 100,
                    height: 30,
                    child: DefaultBtn(
                        event: () => call(),
                        title: "Appeler",
                        titleSize: 10,
                        bgColor: kPrimaryColor))
              ],
            )
          ],
        )
      ]),
    );
  }
}
