import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String queueCollection = 'queue';
  final String bookingCollection = 'bookings';

  Stream<QuerySnapshot<Map<String, dynamic>>> get queueStream =>
      _db.collection(queueCollection).orderBy('joinedAt').snapshots();

  Future<void> joinQueue(String name, int seats) async {
    if (name.trim().isEmpty) return;
    await _db.collection(queueCollection).add({
      'name': name.trim(),
      'seats': seats,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> serveNextCustomer({
    required Function(String msg) onServed,
  }) async {
    final queueQuery =
        await _db
            .collection(queueCollection)
            .orderBy('joinedAt')
            .limit(1)
            .get();
    if (queueQuery.docs.isEmpty) return;

    final next = queueQuery.docs.first;
    final nextId = next.id;
    final nextName = next['name'] ?? 'Unknown';
    final seats = next['seats'] ?? 1;

    // Save booking history
    await _db.collection(bookingCollection).add({
      'customerName': nextName,
      'trainId': 'train1',
      'seats': seats,
      'bookedAt': FieldValue.serverTimestamp(),
    });

    // Remove from queue
    await _db.collection(queueCollection).doc(nextId).delete();

    onServed("$nextName booked $seats seat(s)!");
  }
}
