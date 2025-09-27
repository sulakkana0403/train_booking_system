import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/train_bg.jpg",
                ), // <-- Add image in assets
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔹 Semi-transparent overlay for readability
          Container(color: Colors.black.withOpacity(0.5)),

          /// 🔹 Page content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '🚆 Welcome to Train Booking System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// 🔹 Card 1
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: const Icon(
                        Icons.train,
                        size: 40,
                        color: Colors.blue,
                      ),
                      title: const Text(
                        'Book a Train',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text("Reserve seats quickly and easily"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.pushNamed(context, '/booking'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 Card 2
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: const Icon(
                        Icons.info,
                        size: 40,
                        color: Colors.green,
                      ),
                      title: const Text(
                        'View Trains',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text("Check available trains & details"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.pushNamed(context, '/train-info'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 🔹 Card 3
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: const Icon(
                        Icons.history,
                        size: 40,
                        color: Colors.orange,
                      ),
                      title: const Text(
                        'Booking History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: const Text("View your past reservations"),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.pushNamed(context, '/history'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
