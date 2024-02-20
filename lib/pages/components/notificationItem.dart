import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/alertPivot.dart';

class NotificationItem extends StatefulWidget {
  final AlertPivot alertPivot;
  const NotificationItem({super.key, required this.alertPivot});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  String? status;
  Color? statusColor;
  String dateParsed = "";

  @override
  void initState() {
    super.initState();
  }

  void parseDate(Timestamp timestamp) async {
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + (timestamp.nanoseconds / 1000000).round());
    await initializeDateFormatting('fr', '');
    final formattedDate =
        DateFormat('EEEE d MMMM à HH\'h\'mm', 'fr').format(dt);
    setState(() {
      dateParsed = formattedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.alertPivot.alert.alertStatus) {
      case "IN PROGRESS":
        statusColor = Colors.orange;
        break;
      case "IN DANGER":
        statusColor = Colors.red;
        break;
      case "SAFE":
        statusColor = Colors.green;
        break;
    }
    switch (widget.alertPivot.alert.alertStatus) {
      case "IN PROGRESS":
        status = "NON REPONDU";
        break;
      case "IN DANGER":
        status = "EN DANGER";
        break;
      case "SAFE":
        status = "HORS DE DANGER";
        break;
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(100)),
            child: Center(
                child: Text(
              "SOS",
              style: TextStyle(color: kPrimaryColor, fontSize: 17),
            )),
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(255, 205, 201, 201)),
                      child: Text(
                        "ALERTE ${widget.alertPivot.alert.alertType}",
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      dateParsed,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Alerte de vérification: lancé par ${widget.alertPivot.employee.lastname} ${widget.alertPivot.employee.firstname}",
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      "Votre statut:",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      status!,
                      style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: statusColor,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
