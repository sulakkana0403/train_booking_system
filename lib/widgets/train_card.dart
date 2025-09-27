import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class TrainCard extends StatelessWidget {
  final FirestoreService service;
  const TrainCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: service.trainStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const LinearProgressIndicator();
        final data = snapshot.data!.data();
        if (data == null) return const Text('Train not found.');
        final name = data['name'] ?? 'Train';
        final total = data['totalSeats'] ?? 0;
        final available = data['availableSeats'] ?? 0;
        return Card(
          child: ListTile(
            title: Text(name.toString()),
            subtitle: Text('Available: $available / $total'),
          ),
        );
      },
    );
  }
}
