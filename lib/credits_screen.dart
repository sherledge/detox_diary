import 'package:flutter/material.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC1D2DA),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            const SizedBox(height: 50), 
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
               
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Credits',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Divider(color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 10),
                  buildTeamMember('Anex Shaju', 'Research Lead, 7 supply'),
                  buildTeamMember('Shabeer', 'Technical Operations, 3 supply'),
                  buildTeamMember('Aswin Das CH', 'Marketing, 8 supply'),
                  buildTeamMember('Gowthamkrishna VP', 'HR, 8 supply'),
                  buildTeamMember('Toms John', 'Ex ICCS Dropout'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTeamMember(String name, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
