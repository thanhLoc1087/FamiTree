import 'package:flutter/material.dart';

enum EMainMenu {
  home(
    id: 'home',
    title: 'Home',
    iconData: Icons.home_outlined
  ),
  chart(
    id: 'chart',
    title: 'Chart',
    iconData: Icons.table_chart_outlined
  ),
  profile(
    id: 'profile',
    title: 'Profile',
    iconData: Icons.person_2_outlined
  ),
  settings(
    id: 'settings',
    title: 'Settings',
    iconData: Icons.settings_outlined
  ),
  ;

  final String id;
  final IconData iconData;
  final String title;

  const EMainMenu({
    required this.id,
    required this.title,
    required this.iconData,
  });
}
