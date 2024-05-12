import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:famitree/src/views/auth/views/forgot_password_page.dart';
import 'package:famitree/src/views/auth/views/login_page.dart';
import 'package:famitree/src/views/auth/views/pre_login_page.dart';
import 'package:famitree/src/views/auth/views/register_page.dart';
import 'package:famitree/src/views/auth/views/change_password_page.dart';
import 'package:famitree/src/views/auth/views/verify_page.dart';
import 'package:famitree/src/views/manage_achievement_type/manage_achievement_type_page.dart';
import 'package:famitree/src/views/manage_death_cause/manage_death_cause_page.dart';
import 'package:famitree/src/views/manage_place/manage_place_page.dart';
import 'package:famitree/src/views/update_profile/update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'services/notifiers/current_user.dart';
import 'views/main/main_page.dart';
import 'views/manage_job/manage_job_page.dart';
import 'views/manage_relationship_type/manage_relationship_type_page.dart';
import 'views/settings/settings_controller.dart';
import 'views/settings/settings_view.dart';
import 'views/splash/splash_page.dart';
import 'views/update_profile/views/update_profile_uploader.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return RepositoryProvider(
      create: (context) => AllRepository(),
      child: ChangeNotifierProvider<CurrentUser>.value(
        value: CurrentUser(),
        child: ListenableBuilder(
          listenable: settingsController,
          builder: (BuildContext context, Widget? child) {
            return MaterialApp(
              // Providing a restorationScopeId allows the Navigator built by the
              // MaterialApp to restore the navigation stack when a user leaves and
              // returns to the app after it has been killed while running in the
              // background.
              restorationScopeId: 'app',

              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
              ],

              // Use AppLocalizations to configure the correct application title
              // depending on the user's locale.
              //
              // The appTitle is defined in .arb files found in the localization
              // directory.
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,

              // Define a light and dark color theme. Then, read the user's
              // preferred ThemeMode (light, dark, or system default) from the
              // SettingsController to display the correct theme.
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.black,
                // brightness: Brightness.dark,
                colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: AppColor.primary,
                  secondary: Colors.black,
                ),
                textTheme: TextTheme(
                    bodyMedium: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColor.text,
                ))),
              ),
              // darkTheme: ThemeData.dark(),
              themeMode: settingsController.themeMode,
              home: const SplashPage(),

              // Define a function to handle named routes in order to support
              // Flutter web url navigation and deep linking.
              onGenerateRoute: (RouteSettings routeSettings) {
                return MaterialPageRoute<void>(
                  settings: routeSettings,
                  builder: (BuildContext context) {
                    debugPrint('route ${routeSettings.name}');
                    switch (routeSettings.name) {
                      case AppRouter.settings:
                        return SettingsView(controller: settingsController);

                      case AppRouter.main:
                        return const MainPage();

                      // AUTHENTICATION
                      case AppRouter.preLogin:
                        return const PreLoginPage();
                      case AppRouter.login:
                        return const LoginPage();
                      case AppRouter.register:
                        return const RegisterPage();
                      case AppRouter.changePassword:
                        return const ChangePasswordPage();
                      case AppRouter.forgotPassword:
                        return const ForgotPasswordPage();
                      case AppRouter.verify:
                        return const VerifyEmailPage();

                      /// ADMIN
                      case AppRouter.manageAchievementType:
                        return const ManageAchievementTypePage();
                      case AppRouter.manageRelationshipType:
                        return const ManageRelationshipTypePage();
                      case AppRouter.manageJobs:
                        return const ManageJobPage();
                      case AppRouter.managePlaces:
                        return const ManagePlacePage();
                      case AppRouter.manageDeathCauses:
                        return const ManageDeathCausePage();
                      
                      case AppRouter.updateProfile:
                        return const UpdateProfilePage();
                      case AppRouter.updateProfilePic:
                        return const UserProfileUploader();

                      default:
                        return const MainPage();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}


/// Family tree
/// 1. Cây của mình
///   Mã chia sẻ cây
///   Thêm, xóa, sửa tv
///   Mời đóng góp
///   Xuất ảnh
/// 2. Thành tích
/// 3. Xem cây người khác
/// 4. Cài đặt 
///   Xóa cây
///   Xóa tài khoản