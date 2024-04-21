import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000), () {
      debugPrint(AppRouter.main);
      Navigator.popAndPushNamed(context, AppRouter.main);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 300),
          child: Text(
            'famiTree',
            style: GoogleFonts.allura(
              color: AppColor.primary,
              fontSize: 100,
            ),
          ),
        ),
      ),
    );
  }
}