import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/functions.dart';
import 'package:vbs_sos/models/apiResponseModel.dart';
import 'package:vbs_sos/pages/components/autorizationItem.dart';
import 'package:vbs_sos/pages/components/defaltBtn.dart';
import 'package:vbs_sos/pages/components/defaultTextField.dart';
import 'package:vbs_sos/pages/mainpage.dart';
import 'package:vbs_sos/services/api_services.dart';
import 'package:vbs_sos/services/local_db_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAgree = false;
  bool isLogin = false;
  PageController controller = PageController();
  final loader = SpinKitCircle(
    color: kSecondaryColor,
    size: 50.0,
  );
  final DatabaseManager dbManager = DatabaseManager.instance;

  @override
  void initState() {
    super.initState();
  }

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  void toStart() async {
    if (!isAgree) {
      showToast(
          "Vous n'avez pas encore accepter les conditions et politiques de confidentialités.",
          ToastType.ERROR);
    } else {
      //Go to login Page
      toPage(1);
      checkPermission();
    }
  }

  void login(String phone, String password, BuildContext context) async {
    setState(() {
      isLogin = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isLogin = false;
            });
            Navigator.pop(context);
            return;
          },
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  kSecondaryColor), // Changez la couleur ici
            ),
          ),
        );
      },
    );
    ApiResponseModel response = await loginAPI(phone, password);

    if (response.message == "L'utilisateur s'est connecté avec succès.") {
      showToast("Connexion réussie", ToastType.SUCCESS);
      Navigator.push(
          context,
          PageTransition(
              duration: Duration(milliseconds: 1000),
              type: PageTransitionType.scale,
              alignment: Alignment.bottomCenter,
              child: const Mainpage()));
    } else {
      Navigator.pop(context);
      showToast(response.message, ToastType.ERROR);
    }

    setState(() {
      isLogin = false;
    });
  }

  void checkPermission() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
  }

  void toPage(int page) {
    controller.animateToPage(page,
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryColor,
        body: SizedBox(
            height: kHeight(context) * 1.1,
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: kHeight(context) * 1.1,
                      child: Stack(children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            height: 430,
                            width: kWidth(context),
                            decoration: BoxDecoration(color: kWhite),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    "VBS-SOS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "votre assistance en danger est un droit",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: kTextColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  Image.asset("assets/images/started-img.png",
                                      scale: 500 / 160)
                                ]),
                          ),
                        ),
                        Positioned(
                            top: 350,
                            left: 0,
                            child: Material(
                              color: Colors.transparent,
                              elevation: 40,
                              child: Container(
                                height: 400,
                                width: kWidth(context),
                                color: Colors.transparent,
                                child: PageView(
                                  controller: controller,
                                  allowImplicitScrolling: false,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padEnds: false,
                                  children: [
                                    //================STARTED VIEW================================
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: kWidth(context) * 0.1,
                                        ),
                                        Expanded(
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                              height: 400,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  const AutorizationItem(
                                                      icon: Bootstrap.geo_alt,
                                                      title:
                                                          "Geolocalisation en temps réel"),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  const AutorizationItem(
                                                      icon: Bootstrap
                                                          .telephone_fill,
                                                      title:
                                                          "Appel immédiat en cas d'alerte"),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        kWidth(context) * 0.65,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Checkbox(
                                                          value: isAgree,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              isAgree = value!;
                                                            });
                                                          },
                                                          activeColor:
                                                              kSecondaryColor,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              kWidth(context) *
                                                                  0.51,
                                                          child:
                                                              GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      isAgree =
                                                                          !isAgree;
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    "J'accepte les conditions et les politiques de confidentialités.",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                    style: TextStyle(
                                                                        color:
                                                                            kTextColor,
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        kWidth(context) * 0.5,
                                                    child: DefaultBtn(
                                                        event: () {
                                                          toStart();
                                                        },
                                                        titleSize: 15,
                                                        title: "Commencer",
                                                        bgColor:
                                                            kSecondaryColor),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        kWidth(context) * 0.5,
                                                    child: Text(
                                                      "En continuant vous acceptez être géolocaliser ou/et téléphoner via VBS-SOS en cas d'alerte de votre part.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: kTextColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: kWidth(context) * 0.1,
                                        ),
                                      ],
                                    ),

                                    //================LOGIN VIEW================================
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: kWidth(context) * 0.1,
                                        ),
                                        Expanded(
                                          child: Material(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Container(
                                              height: 400,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 15,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        kWidth(context) * 0.7,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () =>
                                                              toPage(0),
                                                          child: const Icon(
                                                            Icons.arrow_back,
                                                            size: 27,
                                                          ),
                                                        ),
                                                        Container()
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "CONNEXION",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: kSecondaryColor,
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    height: 40,
                                                  ),
                                                  DefaultTextField(
                                                      controller:
                                                          _phoneController,
                                                      hintText:
                                                          'Ex:+226 60 60 60 60',
                                                      title: "Téléphone",
                                                      prefixIcon: Bootstrap
                                                          .telephone_fill,
                                                      width: kWidth(context) *
                                                          0.55),
                                                  const SizedBox(
                                                    height: 25,
                                                  ),
                                                  DefaultTextField(
                                                      controller:
                                                          _passwordController,
                                                      hintText:
                                                          'Entrer votre mot de passe',
                                                      title: "Mot de passe",
                                                      obscurText: true,
                                                      prefixIcon:
                                                          Bootstrap.key_fill,
                                                      width: kWidth(context) *
                                                          0.55),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        kWidth(context) * 0.5,
                                                    child: isLogin
                                                        ? loader
                                                        : DefaultBtn(
                                                            event: () {
                                                              login(
                                                                  _phoneController
                                                                      .text,
                                                                  _passwordController
                                                                      .text,
                                                                  context);
                                                            },
                                                            titleSize: 15,
                                                            title:
                                                                "Se Connecter",
                                                            bgColor:
                                                                kSecondaryColor),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        kHeight(context) * 0.03,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: kWidth(context) * 0.1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ]),
                    )
                  ],
                ))));
  }
}
