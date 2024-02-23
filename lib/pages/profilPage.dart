import 'package:flutter/material.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/components/ProfilDataLine.dart';
import 'package:vbs_sos/pages/components/changePasswordModal.dart';
import 'package:vbs_sos/pages/components/defaltBtn.dart';

class ProfilPage extends StatefulWidget {
  final Employee employee;
  const ProfilPage({super.key, required this.employee});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          elevation: 0,
          title: Container(
            padding: const EdgeInsets.only(left: 30.0),
            child: const Text(
              'Mon Profil',
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: kHeight(context) * 1.2,
                  child: Stack(children: [
                    Positioned(
                        top: 430,
                        child: SizedBox(
                          height: kHeight(context),
                          width: kWidth(context),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: kWidth(context) * 0.1,
                                    ),
                                    Expanded(
                                      child: Column(children: [
                                        ProfilDataLine(
                                          label: "Nom",
                                          value: widget.employee.firstname,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        ProfilDataLine(
                                          label: "Prénom",
                                          value: widget.employee.lastname,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        ProfilDataLine(
                                          label: "Téléphone",
                                          value: widget.employee.phone_number,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        ProfilDataLine(
                                          label: "Job",
                                          value: widget.employee.job,
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        ProfilDataLine(
                                          label: "Role",
                                          value: widget.employee.role,
                                        ),
                                        const SizedBox(
                                          height: 25,
                                        ),
                                        SizedBox(
                                          width: 210,
                                          child: DefaultBtn(
                                              event: () {
                                                showChangePasswordModal(
                                                    context, widget.employee);
                                              },
                                              titleSize: 15,
                                              title: "Changer mot de passe",
                                              bgColor: kSecondaryColor),
                                        ),
                                      ]),
                                    ),
                                    Container(
                                      width: kWidth(context) * 0.1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: 250,
                        width: kWidth(context),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(80),
                                bottomRight: Radius.circular(80)),
                            color: kSecondaryColor),
                      ),
                    ),
                    Positioned(
                        top: 160,
                        left: 0,
                        child: Material(
                          color: Colors.transparent,
                          elevation: 40,
                          child: Container(
                            height: 240,
                            width: kWidth(context),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: kWidth(context) * 0.1,
                                ),
                                Expanded(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      height: 240,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    border: Border.all(
                                                        width: 2,
                                                        color: kPrimaryColor)),
                                              ),
                                              Container()
                                            ],
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                width: 120,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: kSecondaryColor
                                                          .withOpacity(0.6),
                                                      spreadRadius: 5,
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(10, 10),
                                                    ),
                                                  ],
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      widget.employee.profilUrl,
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 5,
                                                right: 10,
                                                child: SizedBox(
                                                  width: 30,
                                                  height: 30,
                                                  child: Center(
                                                      child:
                                                          FloatingActionButton(
                                                    onPressed: () {},
                                                    backgroundColor: kWhite,
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 15,
                                                      color: kSecondaryColor,
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "@${widget.employee.lastname} ${widget.employee.firstname}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "--${widget.employee.job}--",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )
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
                          ),
                        ))
                  ]),
                )
              ],
            )));
  }
}
