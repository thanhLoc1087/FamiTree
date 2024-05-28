import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/views/common/achievement_type_filter.dart';
import 'package:famitree/src/views/common/day_picker.dart';
import 'package:famitree/src/views/common/keyboard_dismiss.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc.dart';

class EditAchievementForm extends StatefulWidget {
  const EditAchievementForm({
    super.key, 
    required this.member,
    required this.achievement,
  });

  final Member member;
  final Achievement? achievement;

  @override
  State<EditAchievementForm> createState() => _EditAchievementFormState();
}

class _EditAchievementFormState extends State<EditAchievementForm> {
  String? generalError;

  AchievementType? achievementType;
  late ValueNotifier<DateTime> date;
  
  late final bool isEditing;

  @override
  void initState() {
    super.initState();
    date = ValueNotifier(widget.achievement?.time ?? DateTime.now());
    achievementType = widget.achievement?.type;
    isEditing = widget.achievement != null;
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<HomePageBloc>(context).add(const LoadDataHomeEvent());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _submit() async {
    if (achievementType == null) {
      setState(() {
        generalError = "Choose achievement type";
      });
      return;
    }
    final updateAchievement = Achievement(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: achievementType!, 
      time: date.value
    );
    if (isEditing) {
      BlocProvider.of<HomePageBloc>(context)
        .add(UpdateAchievementEvent(widget.member, updateAchievement));
    }
    BlocProvider.of<HomePageBloc>(context)
      .add(AddAchievementEvent(widget.member, updateAchievement));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomePageBloc, HomePageState>(
      listener: (context, state) {
        if (state is CompleteUpdateHomePageState) {
          Navigator.of(context).pop();
        }
      },
      child: KeyboardDismiss(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.sizeOf(context).height / 24,
            bottom: MediaQuery.sizeOf(context).height / 24
          ),
          // padding: const EdgeInsets.only(top: 10),
          child: Material(
            color: Colors.transparent,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Container(
                  width: ScreenUtils.isTablet()
                      ? MediaQuery.sizeOf(context).width * 0.7
                      : MediaQuery.sizeOf(context).width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "${isEditing ? 'Edit ': 'Add'} member achievement",
                                style: const TextStyle(
                                  color: AppColor.text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Date",
                              style: TextStyle(
                                color: AppColor.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ValueListenableBuilder(
                              valueListenable: date,
                              builder: (context, value, child) => DayPicker(
                                initTime: value,
                                onChanged: (p0) {
                                  if (p0 != null) {
                                    date.value = p0;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Achievement type",
                              style: TextStyle(
                                color: AppColor.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return AchievementTypeFilter(
                                      allValues: state.achievementTypes,
                                      onSelected: (type) {
                                        achievementType = type;
                                      },
                                      initText: achievementType?.name ?? "",
                                      width: constraints.maxWidth,
                                    );
                                  },
                                );
                              },
                            ),
                            if (generalError != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                generalError!,
                                style: const  TextStyle(
                                  color: AppColor.danger
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.interactive,
                                fixedSize:
                                    Size(MediaQuery.sizeOf(context).width, 50),
                              ),
                              child: const Text(
                                "SAVE",
                                style: TextStyle(color: AppColor.text),
                              ),
                            )
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.clear,
                            size: 30,
                          ),
                          color: AppColor.text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
