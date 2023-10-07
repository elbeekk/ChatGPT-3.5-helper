import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:test_app/app_constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Drawer(
      child: Center(
        child: Column(
          children: [
            Container(
              color: Constants.mainColor,
              height: h*0.25,
              width: w,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                        width: w*0.25,
                        child: Lottie.asset('assets/male.json'))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
