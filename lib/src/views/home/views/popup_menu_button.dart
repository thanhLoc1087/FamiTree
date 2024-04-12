import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/views/common/ordinary_button.dart';
import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatefulWidget {
  const MyFloatingActionButton({super.key});

  @override
  State<MyFloatingActionButton> createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  late final ValueNotifier<bool> _isMenuOpen;
  @override
  void initState() {
    _isMenuOpen = ValueNotifier(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isMenuOpen,
      builder: (BuildContext context, value, Widget? child) {  
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (value) 
            AnimatedOpacity(
              opacity: value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 1500),
              child: Container(
                margin: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: value
                      ? _additionalButtons(context)
                      : <Widget>[],
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // Toggle the state of the menu
                _isMenuOpen.value = !value;
              },
              backgroundColor: AppColor.accent,
              child: Icon(value ? Icons.close : Icons.add),
            ),
            // If the menu is open, display additional buttons
          ],
        );
      },
    );
  }

  List<Widget> _additionalButtons(BuildContext context) {
    return [
      OrdinaryButton(
        onPressed: () {
          // Handle the action for the first additional button
          // For example, you can navigate to another screen
        },
        text: 'Button 1',
      ),
      const SizedBox(height: 20,),
      OrdinaryButton(
        onPressed: () {
          // Handle the action for the second additional button
          // For example, you can show a dialog
        },
        text: 'Button 2',
      ),
      const SizedBox(height: 20,),
      // Add more buttons as needed
    ];
  }
}