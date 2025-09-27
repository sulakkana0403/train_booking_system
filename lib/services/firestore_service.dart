import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String trainDocId = 'train1';

  Stream<DocumentSnapshot<Map<String, dynamic>>> get trainStream =>
      _db.collection('trains').doc(trainDocId).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> get queueStream =>
      _db.collection('queue').orderBy('joinedAt').snapshots();

  Future<void> joinQueue(String name, {int seats = 1}) async {
    if (name.trim().isEmpty) return;
    await _db.collection('queue').add({
      'name': name.trim(),
      'seats': seats,
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> serveNextCustomer() async {
    final queueQuery =
        await _db.collection('queue').orderBy('joinedAt').limit(1).get();
    if (queueQuery.docs.isEmpty) return;

    final next = queueQuery.docs.first;
    final data = next.data();
    final nextId = next.id;
    final nextName = data['name'] ?? 'Unknown';
    final seats = data.containsKey('seats') ? data['seats'] : 1;

    final trainRef = _db.collection('trains').doc(trainDocId);
    final bookingRef = _db.collection('bookings').doc();

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(trainRef);
      final trainData = snapshot.data()!;
      final available = (trainData['availableSeats'] ?? 0) as int;
      if (available < seats) throw Exception('Not enough seats available');

      transaction.update(trainRef, {'availableSeats': available - seats});
      transaction.set(bookingRef, {
        'customerName': nextName,
        'trainId': trainDocId,
        'seats': seats,
        'bookedAt': FieldValue.serverTimestamp(),
      });
      transaction.delete(_db.collection('queue').doc(nextId));
    });
  }
}
