import 'package:famitree/src/core/constants/colors.dart';
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
  viewTree(
    id: 'viewTree',
    title: 'View Tree',
    iconData: Icons.show_chart
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

  achievementTypes(
    id: 'achievementTypes',
    title: 'Achievement Types',
    iconData: Icons.badge_outlined
  ),
  relationshipTypes(
    id: 'relationshipTypes',
    title: 'Relationship Types',
    iconData: Icons.badge_outlined
  ),
  places(
    id: 'places',
    title: 'Places',
    iconData: Icons.place_outlined
  ),
  jobs(
    id: 'jobs',
    title: 'Jobs',
    iconData: Icons.work_outline
  ),
  deathCauses(
    id: 'deathCauses',
    title: 'Causes of Death',
    iconData: Icons.dangerous_outlined
  ),
  updateProfile(
    id: 'updateProfile',
    title: 'Update Profile',
    iconData: Icons.person_2_outlined
  ),
  forgotPassword(
    id: 'forgotPassword',
    title: 'Forgot Password',
    iconData: Icons.password
  ),
  logout(
    id: 'logout',
    title: 'Log out',
    iconData: Icons.logout,
    color: AppColor.danger
  ),
  ;

  final String id;
  final IconData iconData;
  final String title;
  final Color color;

  const EMainMenu({
    required this.id,
    required this.title,
    required this.iconData,
    this.color = AppColor.text,
  });
}
