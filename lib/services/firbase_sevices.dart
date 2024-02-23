import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vbs_sos/models/alertPivot.dart';

Stream<List<AlertPivot>> streamAlertPivots(
    int employeeId, int companyId, String status) {
  return FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('employee.companyId', isEqualTo: companyId)
      .snapshots()
      .asyncMap((querySnapshot) async {
    List<AlertPivot> allAlerts = [];

    for (DocumentSnapshot doc in querySnapshot.docs) {
      AlertPivot alertPivot = AlertPivot.fromFirestore(doc);

      QuerySnapshot inProgressAlertsSnapshot = await doc.reference
          .collection('in_progress_alerts')
          .where('employee.role', isEqualTo: "USER")
          .where('alert.alertStatus', isEqualTo: status)
          .get();

      List<AlertPivot> inProgressAlerts = inProgressAlertsSnapshot.docs
          .map((doc) => AlertPivot.fromFirestore(doc))
          .toList();

      // Ajoutez les alertes en cours associées à l'alerte principale
      alertPivot.alertsInProgress = inProgressAlerts;

      allAlerts.add(alertPivot);
    }

    return allAlerts;
  });
}

Stream<List<AlertPivot>> streamAllAlertPivots(int employeeId) {
  return FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('employee.employeeId', isEqualTo: employeeId)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => AlertPivot.fromFirestore(doc))
        .toList();
  });
}

Future<int> countAlerts(int employeeId, String status) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('employee.employeeId', isEqualTo: employeeId)
      .where('alert.alertStatus', isEqualTo: status)
      .get();

  return querySnapshot.size;
}
