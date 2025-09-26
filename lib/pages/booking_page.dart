import 'package:flutter/material.dart';
import '../widgets/train_card.dart';
import '../widgets/queue_list.dart';
import '../widgets/customer_input.dart';
import '../services/firestore_service.dart';
import '../services/queue_service.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final FirestoreService _trainService = FirestoreService();
  final QueueService _queueService = QueueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Train Booking (Queue)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrainCard(service: _trainService),
            const SizedBox(height: 12),
            CustomerInput(queueService: _queueService),
            const SizedBox(height: 16),
            const Text(
              'Queue (First to be served on top):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Expanded(child: QueueList(queueService: _queueService)),
          ],
        ),
      ),
    );
  }
}
