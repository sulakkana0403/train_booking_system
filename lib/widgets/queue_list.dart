import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class QueueList extends StatelessWidget {
  final FirestoreService service;
  const QueueList({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: service.queueStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading queue...');
        final qs = snapshot.data!.docs;
        if (qs.isEmpty) return const Text('Queue is empty.');
        return ListView.separated(
          itemCount: qs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final doc = qs[index];
            final data = doc.data() as Map<String, dynamic>;
            final name = data['name'] ?? 'Unknown';
            final seats = data.containsKey('seats') ? data['seats'] : 1;
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(name),
              subtitle: Text('Seats: $seats'),
            );
          },
        );
      },
    );
  }
}
