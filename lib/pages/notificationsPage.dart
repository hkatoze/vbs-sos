import 'package:flutter/material.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/alertPivot.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/components/notificationItem.dart';
import 'package:vbs_sos/services/firbase_sevices.dart';

class NotificationsPage extends StatefulWidget {
  final Employee employee;
  const NotificationsPage({super.key, required this.employee});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
                width: 80,
                height: 50,
                child: Icon(
                  Icons.arrow_back,
                  size: 35,
                  color: kWhite,
                ))),
        title: Container(
          padding: const EdgeInsets.only(left: 30.0),
          child: const Text(
            'Notifcations',
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: kSecondaryColor,
        iconTheme: IconThemeData(
          color: kWhite,
        ),
      ),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: kHeight(context) * 0.1,
        ),
        SizedBox(
          height: kHeight(context) * 0.9,
          child: StreamBuilder<List<AlertPivot>>(
              stream: streamAlertPivots(widget.employee.employeeId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {}

                List<AlertPivot> alertPivots = snapshot.data ?? [];

                return ListView.builder(
                    itemCount: alertPivots.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(alertPivot: alertPivots[index]);
                    });
              }),
        )
      ])),
    );
  }
}
