import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/functions.dart';
import 'package:vbs_sos/models/apiResponseModel.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/components/defaltBtn.dart';
import 'package:vbs_sos/pages/components/defaultTextField.dart';
import 'package:vbs_sos/pages/profilPage.dart';
import 'package:vbs_sos/services/api_services.dart';

class ChangePasswordModal extends StatefulWidget {
  final Employee employee;

  const ChangePasswordModal({super.key, required this.employee});

  @override
  State<ChangePasswordModal> createState() => _ChangePasswordModalState();
}

class _ChangePasswordModalState extends State<ChangePasswordModal> {
  final _pageController = PageController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codeController = TextEditingController();
  bool isSend = false;
  String code = "";

  final loader = SpinKitCircle(
    color: kSecondaryColor,
    size: 50.0,
  );
  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.employee.phone_number;
  }

  void nextPage(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Future<void> changePassword() async {
    setState(() {
      isSend = true;
    });
    ApiResponseModel response = await checkCodeForResetPassword(
        widget.employee.phone_number, code, _passwordController.text);
    setState(() {
      isSend = false;
    });

    if (response.message ==
        "Votre mot de passe a été réinitialisé avec succès.") {
      Navigator.pop(context);
      logout(context, ProfilPage(employee: widget.employee));
    } else {
      showToast(response.message, ToastType.ERROR);
    }
  }

  Future<void> checkCode() async {
    setState(() {
      isSend = true;
    });

    if (_codeController.text == code) {
      setState(() {
        isSend = false;
      });
      nextPage(2);
    } else {
      setState(() {
        isSend = false;
      });
      showToast("Code invalide", ToastType.ERROR);
    }
  }

  Future<void> sendCode() async {
    setState(() {
      isSend = true;
    });

    ApiResponseModel response = await resetPassword(_phoneController.text);
    setState(() {
      isSend = false;
    });

    if (response.message ==
        "Un code de vérification a été sur votre numéro de téléphone.") {
      setState(() {
        code = "${response.data!["verificationCode"]}";
      });

      nextPage(1);
    } else {
      showToast(response.message, ToastType.ERROR);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      height: kHeight(context) * 0.5,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kWidth(context) * 0.1),
      child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            //====CHECK PHONE VIEW
            SizedBox(
              height: kHeight(context) * 0.5,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "Changement de mot de passe",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Text(
                        "Entrer votre numéro de téléphone pour recevoir le code de vérification",
                        style: TextStyle(
                          fontSize: 17,
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    DefaultTextField(
                        controller: _phoneController,
                        hintText: 'Ex:+226 60 60 60 60',
                        prefixIcon: Bootstrap.telephone_fill,
                        width: kWidth(context) * 0.55),
                    const SizedBox(
                      height: 25,
                    ),
                    SizedBox(
                      width: kWidth(context) * 0.5,
                      child: isSend
                          ? loader
                          : DefaultBtn(
                              event: () {
                                sendCode();
                              },
                              titleSize: 15,
                              title: "Recevoir le code",
                              bgColor: kSecondaryColor),
                    ),
                  ]),
            ),
            //==========================

            //====CHECK CODE VIEW

            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => nextPage(0),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 27,
                      ),
                    ),
                    const Text(
                      "Vérification du code",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container()
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                  "Entrer le code de vérification que vous avez reçu sur votre numéro.",
                  style: TextStyle(
                    fontSize: 17,
                  )),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: PinCodeTextField(
                  controller: _codeController,
                  pinTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  pinBoxColor: kSecondaryColor,
                  autofocus: true,
                  pinBoxOuterPadding: const EdgeInsets.symmetric(horizontal: 3),
                  highlight: true,
                  highlightColor: kSecondaryColor,
                  defaultBorderColor: kPrimaryColor,
                  hasTextBorderColor: kPrimaryColor,
                  highlightPinBoxColor: kPrimaryColor,
                  maxLength: 6,
                  pinBoxRadius: 10,
                  pinBoxHeight: 40,
                  pinBoxWidth: 40,
                  wrapAlignment: WrapAlignment.spaceBetween,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: kWidth(context) * 0.5,
                child: isSend
                    ? loader
                    : DefaultBtn(
                        event: () {
                          checkCode();
                        },
                        titleSize: 15,
                        title: "Vérifier le code",
                        bgColor: kSecondaryColor),
              ),
            ]),
            //==========================

            //====NEW PASSWORD VIEW

            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => nextPage(1),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 27,
                      ),
                    ),
                    const Text(
                      "Nouveau mot de passe",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container()
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Entrer votre nouveau mot de passe",
                  style: TextStyle(
                    fontSize: 17,
                  )),
              const SizedBox(
                height: 25,
              ),
              DefaultTextField(
                  controller: _passwordController,
                  hintText: 'Entrer votre mot de passe',
                  title: "Mot de passe",
                  obscurText: true,
                  prefixIcon: Bootstrap.key_fill,
                  width: kWidth(context) * 0.55),
              const SizedBox(
                height: 15,
              ),
              DefaultTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirmer votre mot de passe',
                  title: "Confirmer mot de passe",
                  obscurText: true,
                  prefixIcon: Bootstrap.key_fill,
                  width: kWidth(context) * 0.55),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: kWidth(context) * 0.5,
                child: isSend
                    ? loader
                    : DefaultBtn(
                        event: () {
                          changePassword();
                        },
                        titleSize: 15,
                        title: "Valider",
                        bgColor: kSecondaryColor),
              ),
            ]),
            //==========================
          ]),
    );
  }
}

void showChangePasswordModal(BuildContext context, Employee employee) {
  showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      isScrollControlled: true,
      builder: (context) => ChangePasswordModal(
            employee: employee,
          ));
}
