import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String trainDocId = 'train1';

  // Stream for Train info
  Stream<DocumentSnapshot<Map<String, dynamic>>> get trainStream =>
      _db.collection('trains').doc(trainDocId).snapshots();

  // Stream for Queue (FIFO)
  Stream<QuerySnapshot<Map<String, dynamic>>> get queueStream =>
      _db
          .collection('queue')
          .orderBy('joinedAt', descending: false)
          .snapshots();

  // Customer joins the queue
  Future<void> joinQueue(String name) async {
    if (name.trim().isEmpty) return;
    await _db.collection('queue').add({
      'name': name.trim(),
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  // Admin serves next customer
  Future<void> serveNextCustomer() async {
    final queueQuery =
        await _db
            .collection('queue')
            .orderBy('joinedAt', descending: false)
            .limit(1)
            .get();

    if (queueQuery.docs.isEmpty) return;

    final next = queueQuery.docs.first;
    final nextId = next.id;
    final nextName = next['name'] ?? 'Unknown';
    final trainRef = _db.collection('trains').doc(trainDocId);
    final bookingRef = _db.collection('bookings').doc();

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(trainRef);
      final data = snapshot.data();
      if (data == null) throw Exception('Train not found');
      final available = (data['availableSeats'] ?? 0) as int;
      if (available <= 0) throw Exception('Tickets sold out');

      // Update available seats
      transaction.update(trainRef, {'availableSeats': available - 1});

      // Create booking document
      transaction.set(bookingRef, {
        'customerName': nextName,
        'trainId': trainDocId,
        'bookedAt': FieldValue.serverTimestamp(),
        'seatNo': (data['totalSeats'] ?? 0) - (available - 1),
      });

      // Remove customer from queue
      transaction.delete(_db.collection('queue').doc(nextId));
    });
  }
}
