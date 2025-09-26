import 'package:flutter/material.dart';
import '../services/queue_service.dart';

class CustomerInput extends StatefulWidget {
  final QueueService queueService;
  const CustomerInput({super.key, required this.queueService});

  @override
  State<CustomerInput> createState() => _CustomerInputState();
}

class _CustomerInputState extends State<CustomerInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Your Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            await widget.queueService.joinQueue(_controller.text);
            _controller.clear();
          },
          child: const Text('Join Queue'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () async {
            await widget.queueService.serveNextCustomer(
              onServed: (name) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$name served!')));
              },
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Serve Next'),
        ),
      ],
    );
  }
}
