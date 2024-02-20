import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vbs_sos/models/alertPivot.dart';

Stream<List<AlertPivot>> streamAlertPivots(int employeeId) {
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
