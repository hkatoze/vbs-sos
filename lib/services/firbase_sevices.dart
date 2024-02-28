import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vbs_sos/models/alertPivot.dart';
import 'package:rxdart/rxdart.dart';

Future<void> updateAlertStatus(int employeeId, String alertId, String newStatus,
    GeoPoint newLocation) async {
  final alertRef = await FirebaseFirestore.instance
      .collection('alert_pivot')
      .doc(alertId)
      .collection('in_progress_alerts')
      .where('employee.employeeId', isEqualTo: employeeId)
      .get()
      .then((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.reference;
    } else {
      throw Exception('No document found with the provided employee ID');
    }
  });

  await alertRef.update({
    'alert.alertStatus': newStatus,
    'alert.alertLocation': newLocation,
    'alert.alertDatetime': Timestamp.now()
  });
}

Future<void> deleteAlertPivotsFromFireStore(int companyId) async {
  final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('alert.alertType', isEqualTo: "GENERAL")
      .where('alert.companyId', isEqualTo: companyId)
      .get();

  for (DocumentSnapshot doc in querySnapshot.docs) {
    await doc.reference.delete();
  }
}

Stream<List<AlertPivot>> streamAlertPivots(
    int employeeId, int companyId, String status) {
  return FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('alert.alertType', isEqualTo: "GENERAL")
      .where('alert.companyId', isEqualTo: companyId)
      .snapshots()
      .switchMap((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return FirebaseFirestore.instance
          .collection('alert_pivot')
          .doc(doc.id)
          .collection('in_progress_alerts')
          .where('employee.role', isEqualTo: "USER")
          .where('alert.alertStatus', isEqualTo: status)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => AlertPivot.fromFirestore(doc))
              .toList());
    } else {
      return Stream.value([]);
    }
  });
}

Stream<List<AlertPivot>> streamAllAlertPivots(
  int employeeId,
) {
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

Stream<List<AlertPivot>> streamNeedHelpAlerts(
    int companyId, String alertStatus) {
  return FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('employee.companyId', isEqualTo: companyId)
      .where('alert.alertType', isEqualTo: "NEED HELP")
      .where('alert.alertStatus', isEqualTo: alertStatus)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => AlertPivot.fromFirestore(doc))
        .toList();
  });
}

Stream<String> countNeedHelpAlerts(int companyId, String alertStatus) {
  return FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('employee.companyId', isEqualTo: companyId)
      .where('alert.alertType', isEqualTo: "NEED HELP")
      .where('alert.alertStatus', isEqualTo: alertStatus)
      .snapshots()
      .map((querySnapshot) {
    return querySnapshot.docs
        .map((doc) => AlertPivot.fromFirestore(doc))
        .toList()
        .length
        .toString();
  });
}

Stream<String> countAlerts(int companyId, String status) {
  return FirebaseFirestore.instance
      .collection('alert_pivot')
      .where('alert.alertType', isEqualTo: "GENERAL")
      .where('alert.companyId', isEqualTo: companyId)
      .snapshots()
      .switchMap((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return FirebaseFirestore.instance
          .collection('alert_pivot')
          .doc(doc.id)
          .collection('in_progress_alerts')
          .where('employee.role', isEqualTo: "USER")
          .where('alert.alertStatus', isEqualTo: status)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs.length.toString());
    } else {
      return Stream.value("0"); // Retourne 0 si aucun document n'est trouvé
    }
  });
}
