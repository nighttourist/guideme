import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    _simulateLoadingProgress();
  }

  void _simulateLoadingProgress() {
    Future.delayed(Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          progress += 0.05;
          if (progress < 1.0) {
            _simulateLoadingProgress();
          } else {
            // Navigate to Login Page when loading completes
            Navigator.pushReplacementNamed(context, '/');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo with Rounded Corners
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/logo2.gif',
                height: 300,
              ),
            ),
            SizedBox(height: 20),

            // Animated Text
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'Guide Me',
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                  colors: [
                    Colors.blue,
                    Colors.purple,
                    Colors.pink,
                    Colors.yellow,
                    Colors.orange,
                    Colors.green,
                  ],
                  speed: Duration(milliseconds: 300),
                ),
              ],
              isRepeatingAnimation: true,
              repeatForever: true,
            ),
            SizedBox(height: 30),

            // Progress Bar with Moving Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey,
                    color: Colors.blueAccent,
                    minHeight: 8,
                  ),
                  Positioned(
                    left: MediaQuery.of(context).size.width * 0.6 * progress,
                    child: Icon(
                      Icons.directions_run,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Loading Text
            Text(
              'Connecting to the App...',
              style: TextStyle(color: Colors.white54, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
