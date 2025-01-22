import 'package:flutter/material.dart';
import 'home_screen.dart';
class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC1D2DA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         
            Row(
              children: [
                const SizedBox(width: 60,),
                Image.asset(
                  'assets/your_image.png', 
                  width: 300,
                  height: 300,
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 326,
              height: 49,
              child: ElevatedButton(
                onPressed: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black87, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  
                  style: TextStyle(fontSize: 18,color: Colors.black54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
