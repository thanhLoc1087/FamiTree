import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreLoginPage extends StatefulWidget {
  const PreLoginPage({super.key});

  @override
  State<PreLoginPage> createState() => _PreLoginPageState();
}

class _PreLoginPageState extends State<PreLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImage.background,
            fit: BoxFit.cover,
            height: (MediaQuery.of(context).size.height),
            width: (MediaQuery.of(context).size.width),
          ),
          Positioned(
            bottom: 40,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Center(
                    child: Container(
                  margin: const EdgeInsets.only(bottom:4),
                  child: Text(
                    "welcome to famiTree",
                    style: GoogleFonts.abhayaLibre(
                        textStyle: const TextStyle(
                            color: AppColor.text,
                            fontSize: 36.00,
                            fontWeight: FontWeight.bold)),
                    textAlign: TextAlign.left,
                  ),
                )),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: const Divider(
                    color: AppColor.text,
                    height: 25,
                    thickness: 2,
                    indent: 70,
                    endIndent: 70,
                  ),
                ),

                // BUTTON 1

                Center(
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width - 60),
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // <-- Radius
                        ),
                        backgroundColor: AppColor.text,
                      ),
                      child: Text(
                        'LOG IN',
                        style: GoogleFonts.abhayaLibre(
                            textStyle: const TextStyle(
                                color: AppColor.interactive,
                                fontSize: 20.00,)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.login);
                      },
                    ),
                  ),
                ),

                // BUTTON 2

                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: (MediaQuery.of(context).size.width - 60),
                    height: 55,
                    child: OutlinedButton(
                      // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                      
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 2.0, color: Color.fromRGBO(217, 217, 217, 0.3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // <-- Radius
                        ),
                        backgroundColor: AppColor.backgroundComplementary.withAlpha(36),
                      ),
                      child: Text(
                        'CREATE NEW ACCOUNT',
                        style: GoogleFonts.abhayaLibre(
                            textStyle: const TextStyle(
                                color: AppColor.text,
                                fontSize: 20.00,)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRouter.register);
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
