import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/functions.dart';
import 'package:vbs_sos/models/alert.dart';
import 'package:vbs_sos/models/alertPivot.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/components/alertPopup.dart';
import 'package:vbs_sos/pages/components/defaltBtn.dart';
import 'package:vbs_sos/pages/components/myAppBar.dart';
import 'package:vbs_sos/pages/components/myDrawer.dart';
import 'package:vbs_sos/services/api_services.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';

class EmployeePage extends StatefulWidget {
  final Employee? employee;
  const EmployeePage({super.key, this.employee});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  bool isPressed = false;
  bool isSend = false;
  bool sirene = false;
  double? lat;
  double? long;
  TextEditingController messageController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  void alert() async {
    setState(() {
      isSend = true;
    });
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isSend = false;
            });
            Navigator.pop(context);
          },
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
            ),
          ),
        );
      },
    );

    await getLocation();
    var response = await addAlertApi(
        AlertPivot(
          alert: Alert(
            alertDatetime: Timestamp.now(),
            alertLocation: GeoPoint(lat!, long!),
            alertStatus: 'IN DANGER',
            alertType: 'NEED HELP',
            companyId: widget.employee!.companyId,
          ),
          employee: widget.employee!,
        ),
        long!,
        lat!,
        messageController.text);

    if (isSend == true) {
      Navigator.pop(context);
    }
    if (response.message == "SOS envoyé." ||
        response.message == "Alerte envoyée à tous les employées.") {
      launchSirene();
      showToast(response.message, ToastType.SUCCESS);
      HapticFeedback.vibrate();
    } else {
      showToast(response.message, ToastType.ERROR);
    }
  }

  void launchSirene() async {
    setState(() {
      sirene = true;
    });
    await Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        sirene = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Offset distance = isPressed ? const Offset(10, 10) : const Offset(28, 28);
    double blur = isPressed ? 5.0 : 30.0;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: kWhite,
        appBar: MyAppBar(_scaffoldKey, context, widget.employee!),
        drawer: MyDrawer(
          employee: widget.employee!,
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: kHeight(context) * 0.92,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "assets/images/Alert.${sirene ? "gif" : "png"}",
                      scale: sirene ? 13.9 : 8.6,
                    ),
                    SizedBox(
                      height: kHeight(context) * 0.1,
                    ),
                    Center(
                      child: Listener(
                        onPointerUp: (_) => setState(() {
                          //isPressed = false;
                          //alert();
                          //launchSirene();
                        }),
                        onPointerDown: (_) => setState(() {
                          isPressed = true;

                          AwesomeDialog(
                            context: context,
                            animType: AnimType.scale,
                            dialogType: DialogType.question,
                            btnOkText: "ENVOYER",
                            btnOkColor: kSecondaryColor,
                            customHeader: Text(
                              "SOS\nmessage",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21),
                            ),
                            body: Center(
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: messageController,
                                  maxLines: 8, //or null
                                  decoration: const InputDecoration.collapsed(
                                      hintText:
                                          "Ecrivez un message ici (facultatif)"),
                                ),
                              )),
                            ),
                            onDismissCallback: (value) {
                              setState(() {
                                isPressed = false;
                              });
                            },
                            btnOkOnPress: () async {
                              setState(() {
                                isPressed = false;
                              });

                              alert();
                            },
                          ).show();
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: bgColor,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: blur,
                                    offset: -distance,
                                    color: Colors.white,
                                    inset: isPressed),
                                BoxShadow(
                                    blurRadius: blur,
                                    offset: distance,
                                    color: const Color(0xFFA7A9AF),
                                    inset: isPressed)
                              ]),
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/images/alert_btn.png"),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: kHeight(context) * 0.1,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Appuyer sur le bouton pour lancer un SOS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: kHeight(context) * 0.1,
                    )
                  ]),
            )));
  }
}
