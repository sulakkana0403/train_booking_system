import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings =
        FirebaseFirestore.instance
            .collection('bookings')
            .orderBy('bookedAt', descending: true)
            .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('📜 Booking History'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 6,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: bookings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No bookings yet.',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final docData = docs[index].data() as Map<String, dynamic>;

                final customerName = docData['customerName'] ?? 'Unknown';
                final trainId = docData['trainId'] ?? '-';
                final seats = docData['seats'] ?? '-';

                // ✅ Handle both Timestamp and String
                DateTime? bookedAt;
                final bookedAtField = docData['bookedAt'];
                if (bookedAtField != null) {
                  if (bookedAtField is Timestamp) {
                    bookedAt = bookedAtField.toDate();
                  } else if (bookedAtField is String) {
                    bookedAt = DateTime.tryParse(bookedAtField);
                  }
                }

                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Train: $trainId",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Seats: $seats",
                          style: const TextStyle(fontSize: 16),
                        ),
                        if (bookedAt != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            "Booked At: ${bookedAt.toLocal()}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
