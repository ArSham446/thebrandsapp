// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/id_provider.dart';

class Onboardingscreen extends StatefulWidget {
  const Onboardingscreen({Key? key}) : super(key: key);

  @override
  State<Onboardingscreen> createState() => _OnboardingscreenState();
}

class _OnboardingscreenState extends State<Onboardingscreen> {
  Timer? countDowntimer;
  int seconds = 3;
  List<int> discountList = [];
  String supplierId = '';

  @override
  void initState() {
    startTimer();
    context.read<IdProvider>().getDocId();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    countDowntimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
      });
      if (seconds < 0) {
        stopTimer();
        context.read<IdProvider>().getData != ''
            ? Navigator.pushReplacementNamed(context, '/supplier_home')
            : Navigator.pushReplacementNamed(context, '/supplier_login');
      }
      //   print(timer.tick);
      //   print(seconds);
    });
  }

  void stopTimer() {
    countDowntimer!.cancel();
  }

  Widget buildAsset() {
    return Image.asset('images/onboard/supplieronboard.JPEG');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildAsset(),
          Positioned(
            top: 60,
            right: 30,
            child: Container(
              height: 35,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.grey.shade600.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25)),
              child: MaterialButton(
                onPressed: () {
                  stopTimer();
                  supplierId != ''
                      ? Navigator.pushReplacementNamed(
                          context, '/supplier_home')
                      : Navigator.pushReplacementNamed(
                          context, '/supplier_login');
                },
                child:
                    seconds < 1 ? const Text('Skip') : Text('Skip | $seconds'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
