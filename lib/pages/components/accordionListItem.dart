import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
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
    showLocationModal(context, widget.alert.employee,
        "https://www.google.com/maps/search/?api=1&query=$lat,$long");
  }

  Future<void> call() async {
    await FlutterPhoneDirectCaller.callNumber(
        widget.alert.employee.phone_number);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                      : "HORS DE DANGER",
                  style: TextStyle(
                      fontSize: 10,
                      color: widget.alert.alert.alertStatus == "IN DANGER"
                          ? Colors.red
                          : Colors.green),
                ),
              ),
            ]),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                width: 100,
                height: 30,
                child: DefaultBtn(
                    event: () => localize(),
                    titleSize: 10,
                    title: "Localiser",
                    bgColor: kSecondaryColor)),
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
      ]),
    );
  }
}
