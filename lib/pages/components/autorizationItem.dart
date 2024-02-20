import 'package:flutter/material.dart';
import 'package:vbs_sos/constants.dart';

class AutorizationItem extends StatefulWidget {
  final String title;
  final IconData icon;
  const AutorizationItem({super.key, required this.icon, required this.title});

  @override
  State<AutorizationItem> createState() => _AutorizationItemState();
}

class _AutorizationItemState extends State<AutorizationItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kWidth(context) * 0.65,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: kSecondaryColor)),
          child: Icon(
            widget.icon,
            size: 17,
            color: kSecondaryColor,
          ),
        ),
        const SizedBox(
          width: 18,
        ),
        SizedBox(
            width: kWidth(context) * 0.51,
            child: Text(
              widget.title,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: kTextColor, fontSize: 13, fontWeight: FontWeight.bold),
            ))
      ]),
    );
  }
}
