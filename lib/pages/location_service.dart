import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Method to start listening to location changes
  Stream<DocumentSnapshot> startRealtimeLocationUpdates(String riderId) {
    final docRef = db.collection("RealLocation").doc(riderId);
    return docRef.snapshots();
  }

  // Method to get last location by riderId
  Future<Map<String, dynamic>?> getLastLocation(String riderId) async {
    final docRef = db.collection("RealLocation").doc(riderId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    }
    return null; // Return null if no data exists
  }
}
