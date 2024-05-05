
import 'package:cached_network_image/cached_network_image.dart';
import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/core/constants/main_menu_items.dart';
import 'package:famitree/src/core/enums/main_menu.dart';
import 'package:famitree/src/data/models/user.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final Function(int)? onItemClick;

  const MenuDrawer({super.key, this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.background,
      padding: const EdgeInsets.only(top: 30),
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          CircleAvatar(
            radius: 65,
            backgroundColor: AppColor.interactive,
            child: MyUser.currentUser?.profileImage?.isNotEmpty == true ? 
            CircleAvatar(
              radius: 60,
              backgroundImage: CachedNetworkImageProvider(MyUser.currentUser!.profileImage!),
            ) : const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(AppImage.defaultProfile),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              MyUser.currentUser?.name ?? 'Welcome',
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                color: AppColor.text,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          if (MyUser.currentUser?.isAdmin ?? false)
          ...MainMenuItems.adminMenus
              .map((menu) => _SliderMenuItem(
                  item: menu,
                  iconData: menu.iconData,
                  onTap: onItemClick))
          else 
          ...MainMenuItems.userMenus
              .map((menu) => _SliderMenuItem(
                  item: menu,
                  iconData: menu.iconData,
                  onTap: onItemClick))
          ,
        ],
      ),
    );
  }
}

class _SliderMenuItem extends StatelessWidget {
  final EMainMenu item;
  final IconData iconData;
  final Function(int)? onTap;

  const _SliderMenuItem(
      {required this.item,
      required this.iconData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          item.title,
          style: const TextStyle(
            color: AppColor.text, 
            fontFamily: 'Averta_Regular')),
        leading: Icon(iconData, color: AppColor.text),
        onTap: () => onTap?.call(EMainMenu.values.indexOf(item)));
  }
}