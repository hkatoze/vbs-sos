import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/pages/components/alertPopup.dart';
import 'package:vbs_sos/pages/mainpage.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  showNotificationWithPopupContent();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: kWhite,
            ledColor: Colors.white,
            importance: NotificationImportance.Max)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Configuration du gestionnaire pour les messages reçus en arrière-plan
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MaterialApp(
    title: 'VBS-SOS',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
    ),
    home: const VbsSosApp(),
  ));
}

class VbsSosApp extends StatefulWidget {
  const VbsSosApp({Key? key}) : super(key: key);

  @override
  State<VbsSosApp> createState() => _VbsSosAppState();
}

class _VbsSosAppState extends State<VbsSosApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Notification reçue: ${message.data}');
      launchPop(context);
    });

    if (Platform.isIOS) {
      _firebaseMessaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        provisional: false,
      );
    }

    _firebaseMessaging.getToken().then((token) {});
  }

  @override
  Widget build(BuildContext context) {
    return Mainpage();
  }
}

Future<void> showNotificationWithPopupContent() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 0,
        channelKey: 'basic_channel',
        title: 'Alerte de vérification',
        locked: true,
        body: 'Confirmer votre statut de sécurité',
        actionType: ActionType.KeepOnTop,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        notificationLayout: NotificationLayout.Inbox,
        category: NotificationCategory.Alarm),
    actionButtons: [
      NotificationActionButton(
          key: 'EN_DANGER_BUTTON', label: 'EN DANGER', color: Colors.red),
      NotificationActionButton(
          key: 'HORS_DE_DANGER_BUTTON',
          label: 'HORS DE DANGER',
          color: Colors.green),
    ],
  );
}

void launchPop(BuildContext context) async {
  AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.warning,
    body: const AlertPopup(),
  ).show();
}
