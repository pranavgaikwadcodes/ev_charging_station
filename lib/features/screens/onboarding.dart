import 'package:ev_charging_stations/features/authentication/controllers.onboarding/onboarding.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoargingPage(
                image: "assets/img/onboarding_images/welcome.gif",
                title: "Welcome to EV - Charge Connect",
                subTitle: "Powering Your Journey Towards a Greener Tomorrow",
              ),
              OnBoargingPage(
                image: "assets/img/onboarding_images/map.gif",
                title: "Locate Charging Stations Effortlessly",
                subTitle: "Charge Up Anytime, Anywhere",
              ),
              OnBoargingPage(
                image: "assets/img/onboarding_images/charging.gif",
                title: "Plan Your Journey with Ease",
                subTitle: "Seamless Charging Integration",
              ),
            ],
          ),

          // skip Buttons
          const OnBoardingSkip(),

          // Page Indicators
          const OnBoardingPageIndicators(),

          // Next Button
          const OnBoardingNextButton()
        ],
      ),
    );
  }
}

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      bottom: 40,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          OnBoardingController.instance.nextPage();
        },
        child: const Icon(Icons.arrow_right_alt_rounded),
      ));
  }
}

class OnBoardingPageIndicators extends StatelessWidget {
  const OnBoardingPageIndicators({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    return Positioned(
        bottom: 50,
        left: 10,
        child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationCtick, count: 3,
        effect: ExpandingDotsEffect(dotHeight: 6,),));
  }
}

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: kToolbarHeight,
        right: 10,
        child: TextButton(
          onPressed: () {
            OnBoardingController.instance.skipPage();
          },
          child: const Text("Skip"),
        ));
  }
}

class OnBoargingPage extends StatelessWidget {
  const OnBoargingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Image(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            image: AssetImage(image),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
