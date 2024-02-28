import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/functions.dart';
import 'package:vbs_sos/models/alert.dart';
import 'package:vbs_sos/models/alertPivot.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/services/api_services.dart';
import 'package:vbs_sos/services/firbase_sevices.dart';

class AlarmFloatingActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Employee employee;
  AlarmFloatingActionButton(
      {super.key, required this.onPressed, required this.employee});
  @override
  _AlarmFloatingActionButtonState createState() =>
      _AlarmFloatingActionButtonState();
}

class _AlarmFloatingActionButtonState extends State<AlarmFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _bellController;
  bool isSend = false;

  double? lat;
  double? long;

  @override
  void initState() {
    super.initState();

    _bellController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..stop();
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  void sendAlert(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 222, 225, 225),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          title: Text(
            "Voulez-vous vraiment lancer une alerte générale?",
            style: TextStyle(fontSize: 16.0, color: kSecondaryColor),
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      setState(() {
                        isSend = true;
                      });
                      if (isSend) {
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kSecondaryColor),
                                ),
                              ),
                            );
                          },
                        );
                      }
                      await getLocation();
                      var response = await addAlertApi(
                          AlertPivot(
                            alert: Alert(
                              alertDatetime: Timestamp.now(),
                              alertLocation: GeoPoint(lat!, long!),
                              alertStatus: 'SAFE',
                              alertType: 'GENERAL',
                              companyId: widget.employee.companyId,
                            ),
                            employee: widget.employee,
                          ),
                          long!,
                          lat!,
                          "Alerte générale de vérification de statut sécurité.");
                      setState(() {
                        isSend = false;
                      });

                      if (response.message == "SOS envoyé." ||
                          response.message ==
                              "Alerte envoyée à tous les employées.") {
                        widget.onPressed();
                        _bellController.repeat(reverse: true);
                        showToast(response.message, ToastType.SUCCESS);
                        HapticFeedback.vibrate();
                      } else {
                        showToast(response.message, ToastType.ERROR);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kSecondaryColor),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child:
                        const Text('Lancer', style: TextStyle(fontSize: 14.0)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kSecondaryColor),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child:
                        const Text('Annuler', style: TextStyle(fontSize: 14.0)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _bellController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: kPrimaryColor,
      onPressed: () {},
      child: SizedBox(
        width: 150.0,
        height: 150.0,
        child: IconButton(
          splashRadius: 50,
          iconSize: 150,
          onPressed: () async {
            if (_bellController.isAnimating) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 222, 225, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    title: Text(
                      "Alerte générale en cours",
                      style: TextStyle(
                          fontSize: 17.0,
                          color: kSecondaryColor,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      "Voulez-vous vraiment arrêter l'alerte générale?",
                      style: TextStyle(fontSize: 16.0, color: kSecondaryColor),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                widget.onPressed();
                                await deleteAlertPivotsFromFireStore(
                                    widget.employee.companyId);
                                _bellController.stop();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kSecondaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: const Text('Arrêter',
                                  style: TextStyle(fontSize: 14.0)),
                            ),
                            const SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        kSecondaryColor),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: const Text('Continuer',
                                  style: TextStyle(fontSize: 14.0)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              sendAlert(context);
            }
          },
          icon: Lottie.asset(
            'assets/lotties/bell_vibrate.json',
            controller: _bellController,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
