import 'package:flutter/material.dart';
import 'package:vbs_sos/constants.dart';

class ProfilDataLine extends StatelessWidget {
  final String label;
  final String value;
  const ProfilDataLine({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: kSecondaryColor),
          ),
        ),
        SizedBox(
          width: kWidth(context) * 0.15,
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.3),
                width: 1.0,
              ),
            ),
          ),
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
                color: kPrimaryColor),
          ),
        ))
      ]),
    );
  }
}
