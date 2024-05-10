import 'dart:async';

import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late Timer _timer;

  Future<void> verifyEmail() async {
    await AuthService.firebase().sendEmailVerification();
  }

  @override
  void initState() {
    super.initState();
    verifyEmail();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await AuthService.firebase().reloadUser();
      final user = AuthService.firebase().currentUser;
      if (user?.isEmailVerified ?? false) {
        timer.cancel();
        if (!mounted) return;
        await DialogUtils.showMessageDialog(
            context, 'Your email has been successfully verified.');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRouter.main, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppImage.background,
          fit: BoxFit.cover,
          height: (MediaQuery.of(context).size.height),
          width: (MediaQuery.of(context).size.width),
        ),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: AppColor.text,
            // title: const Text("Login"),
          ),
          body: Container(
            padding: const EdgeInsets.all(32),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Verify \nyour account",
                    style: GoogleFonts.abhayaLibre(
                        textStyle: const TextStyle(
                            color: AppColor.text,
                            fontSize: 36.00,
                            fontWeight: FontWeight.w900)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                          "We've sent you an email verification.\nIf you haven't receive your verification, please tap on the button below:",
                          style: TextStyle(
                            color: AppColor.text,
                          )),
                      const SizedBox(
                        height: 60,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(25), // <-- Radius
                            ),
                            backgroundColor: AppColor.interactive,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () async {
                            await AuthService.firebase()
                                .sendEmailVerification();
                          },
                          child: Text(
                            'Send email verification.',
                            style: GoogleFonts.abhayaLibre(
                                textStyle: const TextStyle(
                              color: AppColor.text,
                              fontSize: 20.00,
                            )),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // <-- Radius
                          ),
                          backgroundColor: AppColor.text,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () => {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRouter.main, (route) => false)
                        },
                        child: Text(
                          'Later',
                          style: GoogleFonts.abhayaLibre(
                              textStyle: const TextStyle(
                            color: AppColor.interactive,
                            fontSize: 20.00,
                          )),
                        ),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}
