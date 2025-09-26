import 'package:flutter/material.dart';
import '../services/queue_service.dart';

class QueueList extends StatelessWidget {
  final QueueService queueService;
  const QueueList({super.key, required this.queueService});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: queueService.queueStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('The queue is empty.', textAlign: TextAlign.center),
          );
        }
        final queueDocs = snapshot.data!.docs;
        return ListView.separated(
          itemCount: queueDocs.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final doc = queueDocs[index];
            final name = doc['name'] ?? 'Unknown';
            return ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text(name),
            );
          },
        );
      },
    );
  }
}
