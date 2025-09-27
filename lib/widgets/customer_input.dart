import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class CustomerInput extends StatefulWidget {
  final FirestoreService service;
  const CustomerInput({super.key, required this.service});

  @override
  State<CustomerInput> createState() => _CustomerInputState();
}

class _CustomerInputState extends State<CustomerInput> {
  final TextEditingController _nameController = TextEditingController();
  int _seats = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: _seats,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _seats = value;
              });
            }
          },
          items:
              List.generate(5, (i) => i + 1).map((e) {
                return DropdownMenuItem<int>(value: e, child: Text('$e seats'));
              }).toList(),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () async {
            await widget.service.joinQueue(_nameController.text, seats: _seats);
            _nameController.clear();
            setState(() {
              _seats = 1;
            });
          },
          child: const Text('Join Queue'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: widget.service.serveNextCustomer,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Admin: Serve Next'),
        ),
      ],
    );
  }
}
