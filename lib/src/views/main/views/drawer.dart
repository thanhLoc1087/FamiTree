import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/main_menu_items.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/core/enums/main_menu.dart';
import 'package:famitree/src/core/utils/logout_dialog.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ShopMenuDrawer extends StatelessWidget {
  const ShopMenuDrawer({super.key});

  static int countTap = 0;
  static DateTime lastTap = DateTime.now();

  _tapItem(EMainMenu type, BuildContext context) async {
    switch (type) {
      case EMainMenu.forgotPassword:
        Navigator.of(context).pushNamed(AppRouter.changePassword);
        break;
      case EMainMenu.logout:
        final confirmLogout = await showLogOutDialog(
            context,
            content: 'Logging out?',
            title: 'Log out');
        if (confirmLogout) {
          await AuthService.firebase().logout();
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.login,
            (_) => false,
          );
        }
        break;
      case EMainMenu.home:
        Navigator.of(context).pushNamed(AppRouter.main);
        break;
      case EMainMenu.chart:
        Navigator.of(context).pushNamed(AppRouter.chart);
        break;
      case EMainMenu.profile:
        // TODO: Handle this case.
      case EMainMenu.settings:
        // TODO: Handle this case.
      case EMainMenu.achievementTypes:
        Navigator.of(context).pushNamed(AppRouter.manageAchievementType);
        break;
      case EMainMenu.relationshipTypes:
        Navigator.of(context).pushNamed(AppRouter.manageRelationshipType);
        break;
      case EMainMenu.places:
        Navigator.of(context).pushNamed(AppRouter.managePlaces);
        break;
      case EMainMenu.jobs:
        Navigator.of(context).pushNamed(AppRouter.manageJobs);
        break;
      case EMainMenu.deathCauses:
        Navigator.of(context).pushNamed(AppRouter.manageDeathCauses);
        break;
      case EMainMenu.updateProfile:
        Navigator.of(context).pushNamed(AppRouter.updateProfile);
        break;
      case EMainMenu.viewTree:
        Navigator.of(context).pushNamed(AppRouter.viewTree);
        break;
    }
  }

  DateTime getDay(List<int> weekdays, DateTime time) {
    DateTime d = time.copyWith(month: 9);
    while (!weekdays.contains(d.weekday)) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  @override
  Widget build(BuildContext context) {
    List<EMainMenu> menu = [];
    if (MyUser.currentUser?.isAdmin ?? false) {
      menu.addAll(MainMenuItems.adminMenus);
    } else {
      menu.addAll(MainMenuItems.userMenus);
    }

    return Drawer(
      shape: const RoundedRectangleBorder(
        // borderRadius: BorderRadius.only(
        //   topRight: Radius.circular(15),
        //   bottomRight: Radius.circular(15),
        // ),
      ),
      backgroundColor: AppColor.background,
      width: MediaQuery.of(context).size.width *
          (ScreenUtils.isTablet() ? 0.5 : 0.75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: ScreenUtils.viewPadding.top + 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Material(
                    color: AppColor.background,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.all(10),
                        child: const Icon(Icons.close)
                      ),
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  "Menu",
                  style: TextStyle(
                    color: AppColor.text,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: menu.length,
            itemBuilder: (context, index) {
              return ItemMenu(
                menu: menu[index],
                onPressed: () {
                  _tapItem(menu[index], context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ItemMenu extends StatelessWidget {
  const ItemMenu({super.key, required this.menu, required this.onPressed});

  final EMainMenu menu;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.background,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 55,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: Icon(
                          menu.iconData,
                          color: AppColor.text,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        menu.title,
                        style: TextStyle(
                          color: menu.color,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15,
                        color: AppColor.backgroundComplementary,
                      ),
                    ),
                  )
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Divider(
                  color: AppColor.backgroundComplementary.withAlpha(80),
                  height: 1,
                  indent: 15,
                  endIndent: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
