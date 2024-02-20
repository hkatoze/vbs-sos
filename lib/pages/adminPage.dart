import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vbs_sos/constants.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:vbs_sos/pages/components/myAppBar.dart';
import 'package:vbs_sos/pages/components/myDrawer.dart';

class AdminPage extends StatefulWidget {
  final Employee employee;
  const AdminPage({super.key, required this.employee});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kWhite,
      appBar: MyAppBar(_scaffoldKey, context, widget.employee),
      drawer: MyDrawer(
        employee: widget.employee,
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(12.35, -1.516667),
          initialZoom: 8,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}
