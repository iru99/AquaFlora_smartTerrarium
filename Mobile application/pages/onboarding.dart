import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_terrarium/pages/navigation.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Navigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 18.0);

    const pageDecoration = PageDecoration(
        bodyTextStyle: bodyStyle,
        pageColor: Colors.white,
        imagePadding: EdgeInsets.zero,
        bodyAlignment: Alignment.center);

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      pages: [
        PageViewModel(
          titleWidget: const Text(
            "What is Aqua Flora?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          bodyWidget: const Text(
            "Aqua Flora is a cutting-edge smart terrarium system designed to effortlessly cultivate and maintain vibrant aquatic ecosystems, all conveniently managed through our user- friendly mobile application.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('assets/ob-1.png', width: 200),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Text(
            "Automated Terrarium",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          bodyWidget: const Text(
            "Aqua Flora empowers users by automatically regulating environmental parameters such as temperature, humidity, and lighting, ensuring optimal conditions for the thriving growth of your cherished flora and fauna.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          image: Image.asset('assets/ob-2.png', width: 180),
          decoration: pageDecoration,
        ),
        PageViewModel(
          titleWidget: const Text(
            "Manual System",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
          ),
          bodyWidget: const Text(
            "With Aqua Flora, users have the flexibility to manually adjust environmental settings to meet specific requirements, providing personalized control over terrarium's ecosystem directly from our mobile device",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          image: Image.asset('assets/ob-3.png', width: 200),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
