import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:restart_app/restart_app.dart';
import 'package:vbs_sos/constants.dart';

import 'package:vbs_sos/services/local_db_services.dart';

enum ToastType {
  NORMAL,
  ERROR,
  SUCCESS,
}

void logout(BuildContext context, Widget currentPage) async {
  try {
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
          title: Center(
            child: Text(
              "Voulez-vous vraiment vous déconnectez?\nVous ne recevrez plus d'alertes de votre entreprise ni envoyer d'alertes.",
              style: TextStyle(fontSize: 16.0, color: kSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return GestureDetector(
                            onTap: () {},
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    kSecondaryColor), // Changez la couleur ici
                              ),
                            ),
                          );
                        },
                      );
                      await DatabaseManager.instance.clearDatabase();

                      Fluttertoast.showToast(
                          msg: "Déconnexion",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 15.0);

                      Restart.restartApp();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(kSecondaryColor),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    child: const Text('Oui', style: TextStyle(fontSize: 14.0)),
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
                    child: const Text('Non', style: TextStyle(fontSize: 14.0)),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  } catch (e) {
    showToast("Echec de déconnexion", ToastType.ERROR);
  }
}

void showToast(String message, ToastType type) {
  Color backgroundColor;
  switch (type) {
    case ToastType.NORMAL:
      backgroundColor =
          kSecondaryColor; // Par exemple, utilisez la couleur bleue pour NORMAL
      break;
    case ToastType.ERROR:
      backgroundColor = Colors.red;
      break;
    case ToastType.SUCCESS:
      backgroundColor = Colors.green;
      break;
  }
  Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0);
}
