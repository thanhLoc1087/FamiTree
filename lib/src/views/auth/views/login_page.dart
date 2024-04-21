import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/core/utils/check_connectivity.dart';
import 'package:famitree/src/core/utils/dialogs.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/auth/auth_exceptions.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late bool _isCheckedRememberMe = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadUserEmailPassword();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // REMEMBER ME FEATURE
  void _handleRemeberme() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('remember_me', _isCheckedRememberMe);
      prefs.setString('email', _emailController.text.trim());
      prefs.setString('password', _passwordController.text.trim());
    });
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? "";
      final password = prefs.getString('password') ?? "";
      final rememberMe = prefs.getBool('remember_me') ?? false;
      if (rememberMe) {
        setState(() {
          _isCheckedRememberMe = true;
        });
        _emailController.text = email;
        _passwordController.text = password;
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        AppImage.background,
        fit: BoxFit.cover,
        height: (MediaQuery.of(context).size.height),
        width: (MediaQuery.of(context).size.width),
      ),
      Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          // title: const Text("Login"),
        ),
        body: ListView(children: [
          Container(
              height: MediaQuery.of(context).size.height - 160,
              margin: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log into \nyour account",
                    style: GoogleFonts.abhayaLibre(
                        textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 36.00,
                            fontWeight: FontWeight.w900)),
                  ),
                  Column(
                    children: [
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: GoogleFonts.abhayaLibre(),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: GoogleFonts.abhayaLibre(),
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor:
                                    Theme.of(context).colorScheme.primary,
                                value: _isCheckedRememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _isCheckedRememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                "Remember me",
                                style: GoogleFonts.abhayaLibre(
                                    color: Colors.black),
                              )
                            ],
                          ),
                          TextButton(
                              onPressed: () async {
                                if (!(await checkInternetConnectivity())) {
                                  displayNoInternet();
                                  return;
                                }
                                Navigator.of(context)
                                    .pushNamed(AppRouter.forgotPassword);
                              },
                              child: Text(
                                "Forgot password?",
                                style: GoogleFonts.abhayaLibre(
                                    fontSize: 16,
                                    color: const Color.fromARGB(
                                        255, 100, 100, 100)),
                              ))
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ElevatedButton(
                              // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25), // <-- Radius
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                minimumSize: const Size.fromHeight(50),
                              ),
                              child: Text(
                                'Log in',
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.00,
                                )),
                              ),
                              onPressed: () async {
                                if (!(await checkInternetConnectivity())) {
                                  displayNoInternet();
                                  return;
                                }
                                final emailText = _emailController.text.trim();
                                final passwordText =
                                    _passwordController.text.trim();
                                try {
                                  _handleRemeberme();
                                  await AuthService.firebase().login(
                                      email: emailText, password: passwordText);
                                  final user =
                                      AuthService.firebase().currentUser;
                                  if (user != null) {
                                    Provider.of<CurrentUser>(context,
                                                listen: false)
                                            .user =
                                        (await MyUser.getCurrentUser())!;
                                    final emailVerified = user.isEmailVerified;
                                    if (!mounted) return;
                                    if (emailVerified) {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              AppRouter.main, (route) => false);
                                    } else {
                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              AppRouter.verify, (route) => false);
                                    }
                                  }
                                } on UserNotFoundAuthException {
                                  await showMessageDialog(context,
                                      'This email has not been registered.');
                                } on InvalidEmailAuthException {
                                  await showMessageDialog(
                                      context, 'Invalid email.');
                                } on WrongPasswordAuthException {
                                  await showMessageDialog(
                                      context, 'Wrong password.');
                                } on GenericAuthException {
                                  await showMessageDialog(
                                      context, 'Authentication Error.');
                                } catch (e) {
                                  await showMessageDialog(
                                      context, 'Error: ${e.toString()}');
                                }
                              })),
                      const SizedBox(
                        height: 4,
                      ),
                      ElevatedButton.icon(
                        // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // <-- Radius
                          ),
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.black
                        ),
                        label: Text(
                          'Log in with Google',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16.00,
                          )),
                        ),
                        onPressed: () async {
                          if (!(await checkInternetConnectivity())) {
                            displayNoInternet();
                            return;
                          }
                          try {
                            await AuthService.google()
                                .login(email: '', password: '');
                            final user = AuthService.google().currentUser;
                            if (user != null) {
                              Provider.of<CurrentUser>(context, listen: false)
                                  .user = (await MyUser.getCurrentUser())!;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  AppRouter.main, (route) => false);
                            }
                          } on UserNotLoggedInAuthException {
                            await showMessageDialog(
                                context, 'Login cancelled!');
                          } on UserNotFoundAuthException {
                            await showMessageDialog(context, 'Login failed!');
                          } catch (e) {
                            await showMessageDialog(
                                context, 'Error: ${e.toString()}');
                          }
                        },
                        icon: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Image(
                            image: AssetImage(AppImage.google),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    child: Text(
                      "New to this app? Sign up.",
                      style: GoogleFonts.abhayaLibre(
                          color: Colors.black, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed(AppRouter.register);
                    },
                  ),
                ],
              )),
        ]),
      ),
    ]);
  }
}
