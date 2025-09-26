import 'package:cloud_firestore/cloud_firestore.dart';

class QueueService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String queueCollection = 'queue';

  // Stream of queue (FIFO)
  Stream<QuerySnapshot<Map<String, dynamic>>> get queueStream =>
      _db
          .collection(queueCollection)
          .orderBy('joinedAt', descending: false)
          .snapshots();

  // Customer joins queue
  Future<void> joinQueue(String name) async {
    if (name.trim().isEmpty) return;
    await _db.collection(queueCollection).add({
      'name': name.trim(),
      'joinedAt': FieldValue.serverTimestamp(),
    });
  }

  // Serve the next customer (remove from queue)
  Future<void> serveNextCustomer({
    required Function(String name) onServed,
  }) async {
    final queueQuery =
        await _db
            .collection(queueCollection)
            .orderBy('joinedAt', descending: false)
            .limit(1)
            .get();

    if (queueQuery.docs.isEmpty) return;

    final next = queueQuery.docs.first;
    final nextId = next.id;
    final nextName = next['name'] ?? 'Unknown';

    // Remove from queue
    await _db.collection(queueCollection).doc(nextId).delete();

    // Callback with customer name
    onServed(nextName);
  }
}
