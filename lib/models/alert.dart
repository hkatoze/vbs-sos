import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  final Timestamp alertDatetime;
  final int? alertId;
  final GeoPoint alertLocation;
  final String alertStatus;
  final String alertType;
  final String? message;
  final int companyId;

  Alert(
      {required this.alertDatetime,
      this.alertId,
      required this.alertLocation,
      required this.alertStatus,
      required this.alertType,
      required this.companyId,
      this.message});

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      alertDatetime: map['alertDatetime'],
      alertId: map['alertId'],
      alertLocation: map['alertLocation'],
      alertStatus: map['alertStatus'],
      alertType: map['alertType'],
      message: map['message'],
      companyId: map['companyId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alertDatetime': alertDatetime,
      'alertId': alertId,
      'alertLocation': alertLocation,
      'alertStatus': alertStatus,
      'alertType': alertType,
      'companyId': companyId,
      'message': message,
    };
  }
}
