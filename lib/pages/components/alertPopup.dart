import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/functions.dart';
import 'package:vbs_sos/pages/components/defaltBtn.dart';
import 'package:vbs_sos/pages/components/locationView.dart';

import 'package:vbs_sos/services/firbase_sevices.dart';

class AlertPopup extends StatefulWidget {
  final Map<String, dynamic> notificationData;
  final int employeeId;
  const AlertPopup(
      {super.key, required this.notificationData, required this.employeeId});

  @override
  State<AlertPopup> createState() => _AlertPopupState();
}

class _AlertPopupState extends State<AlertPopup> {
  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  void localize() {
    showLocationModal(context, widget.notificationData['employeeName'],
        "https://www.google.com/maps/search/?api=1&query=${widget.notificationData['alertLocationLat']},${widget.notificationData['alertLocationLong']}");
  }

  Future<void> call() async {
    await FlutterPhoneDirectCaller.callNumber(
        widget.notificationData['employeePhone']);
  }

  void confirmStatut(String status) async {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
            ),
          ),
        );
      },
    );
    await updateAlertStatus(widget.employeeId,
        widget.notificationData['alertId'], status, GeoPoint(lat!, long!));

    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    showToast("Statut confirmé", ToastType.SUCCESS);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(children: [
        Text(
          widget.notificationData['alertType'] == "NEED HELP"
              ? "${widget.notificationData['employeeName']}"
              : "Alerte de vérification",
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: kSecondaryColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          widget.notificationData['alertType'] == "NEED HELP"
              ? "${widget.notificationData['message']}"
              : "Confirmer votre statut de sécurité",
          style: TextStyle(fontSize: 16.0, color: kSecondaryColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 125,
                height: 30,
                child: DefaultBtn(
                    event: () =>
                        widget.notificationData['alertType'] == "NEED HELP"
                            ? localize()
                            : confirmStatut("IN DANGER"),
                    titleSize: 9,
                    title: widget.notificationData['alertType'] == "NEED HELP"
                        ? "Localiser"
                        : "EN DANGER",
                    bgColor: widget.notificationData['alertType'] == "NEED HELP"
                        ? kSecondaryColor
                        : kPrimaryColor)),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
                width: 125,
                height: 30,
                child: DefaultBtn(
                    event: () =>
                        widget.notificationData['alertType'] == "NEED HELP"
                            ? call()
                            : confirmStatut("SAFE"),
                    title: widget.notificationData['alertType'] == "NEED HELP"
                        ? "Apeller"
                        : "HORS DE DANGER",
                    titleSize: 9,
                    bgColor: widget.notificationData['alertType'] == "NEED HELP"
                        ? kPrimaryColor
                        : Colors.green))
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ]),
    );
  }
}
