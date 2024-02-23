import 'package:flutter/material.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/pages/components/defaltBtn.dart';
import 'package:vbs_sos/services/api_services.dart';

class AlertPopup extends StatefulWidget {
  const AlertPopup({super.key});

  @override
  State<AlertPopup> createState() => _AlertPopupState();
}

class _AlertPopupState extends State<AlertPopup> {
  void confirmStatut(String status) async {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Column(children: [
        Text(
          "Alerte de vérification",
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
          "Confirmer votre statut de sécurité",
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
                    event: () {},
                    titleSize: 9,
                    title: "EN DANGER",
                    bgColor: kPrimaryColor)),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
                width: 125,
                height: 30,
                child: DefaultBtn(
                    event: () {},
                    title: "HORS DE DANGER",
                    titleSize: 9,
                    bgColor: Colors.green))
          ],
        ),
        const SizedBox(
          height: 30,
        ),
      ]),
    );
  }
}
