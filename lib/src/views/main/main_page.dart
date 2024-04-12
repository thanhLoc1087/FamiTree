import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/enums/main_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

import '../home/home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Averta'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SliderDrawer(
          key: _sliderDrawerKey,
          appBar: SliderAppBar(
            appBarColor: Colors.white,
            title: Container()
          ),
          sliderOpenSize: 179,
          animationDuration: 200,
          slider: _SliderView(
            onItemClick: (index) {
              if (!kIsWeb) {
                _sliderDrawerKey.currentState!.closeSlider();
              }
              setState(() {
                selectedIndex = index;
              });
            },
          ),
          child: Builder(
            builder: (context) {
              final selectedMenuItem = EMainMenu.values[selectedIndex];
              switch(selectedMenuItem) {
                case EMainMenu.home:
                  return const HomePage();
                case EMainMenu.chart:
                  // TODO: Handle this case.
                case EMainMenu.profile:
                  // TODO: Handle this case.
                case EMainMenu.settings:
                  // TODO: Handle this case.
                default: return Center(child: Text(selectedMenuItem.title),);
              }
            }
          )),
      ),
    );
  }
}

class _SliderView extends StatelessWidget {
  final Function(int)? onItemClick;

  const _SliderView({super.key, this.onItemClick});

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
            child: CircleAvatar(
              radius: 60,
              backgroundImage: Image.network(
                      'https://nikhilvadoliya.github.io/assets/images/nikhil_1.webp')
                  .image,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Nick',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.text,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ...EMainMenu.values
              .map((menu) => _SliderMenuItem(
                  item: menu,
                  iconData: menu.iconData,
                  onTap: onItemClick)),
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
      {super.key,
      required this.item,
      required this.iconData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(item.title,
            style: TextStyle(
                color: AppColor.text, fontFamily: 'Averta_Regular')),
        leading: Icon(iconData, color: AppColor.text),
        onTap: () => onTap?.call(EMainMenu.values.indexOf(item)));
  }
}