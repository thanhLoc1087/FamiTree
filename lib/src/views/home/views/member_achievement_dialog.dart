import 'package:cached_network_image/cached_network_image.dart';
import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/views/common/achievement_type_filter.dart';
import 'package:famitree/src/views/common/day_picker.dart';
import 'package:famitree/src/views/common/keyboard_dismiss.dart';
import 'package:famitree/src/views/common/member_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc.dart';

class MemberAchievementForm extends StatefulWidget {
  const MemberAchievementForm({
    super.key, this.selectedMember,
  });

  final Member? selectedMember;

  @override
  State<MemberAchievementForm> createState() => _MemberAchievementFormState();
}

class _MemberAchievementFormState extends State<MemberAchievementForm> {
  String? generalError;

  AchievementType? achievementType;
  Member? selectedMember;
  late ValueNotifier<DateTime> date;

  @override
  void initState() {
    super.initState();
    selectedMember = widget.selectedMember;
    date = ValueNotifier(DateTime.now());
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

  _submit() {
    if (selectedMember == null) {
      setState(() {
        generalError = "Choose family mamber type";
      });
      return;
    }

    if (achievementType == null) {
      setState(() {
        generalError = "Choose achievement type";
      });
      return;
    }

    Achievement newItem = Achievement(
      id: '', 
      type: achievementType!, 
      time: date.value
    );

    BlocProvider.of<HomePageBloc>(context)
        .add(AddAchievementEvent(selectedMember!, newItem));
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
          padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 12),
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
                                widget.selectedMember != null ? 
                                  "Add ${widget.selectedMember!.name}'s achievement" :
                                  "Add member Achievement",
                                style: const TextStyle(
                                  color: AppColor.text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            if (widget.selectedMember != null) ... [
                              Row(
                                children: [
                                  selectedMember!.image?.isNotEmpty == true ? 
                                  CircleAvatar(
                                      radius: 60,
                                      backgroundImage: CachedNetworkImageProvider(selectedMember!.image!),
                                    ) : const CircleAvatar(
                                      radius: 60,
                                      backgroundImage: AssetImage(AppImage.defaultProfile),
                                    ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selectedMember!.name,
                                        style: const TextStyle(
                                          color: AppColor.text,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                      Text(
                                        '${selectedMember!.homeland.name} - ${selectedMember!.homeland.address}',
                                        style: const TextStyle(
                                          color: AppColor.text,
                                          fontWeight: FontWeight.w500
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ] else ...[
                              const Text(
                                "Member",
                                style: TextStyle(
                                  color: AppColor.text,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return BlocBuilder<HomePageBloc, HomePageState>(
                                    builder: (context, state) {
                                      return MemberFilter(
                                        allValues: state.members,
                                        onSelected: (selected) {
                                          selectedMember = selected;
                                        },
                                        initText: selectedMember?.name ?? "",
                                        width: constraints.maxWidth,
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 10),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return AchievementTypeFilter(
                                      allValues: state.achievementTypes,
                                      onSelected: (selected) {
                                        achievementType = selected;
                                      },
                                      initText: achievementType?.name ?? "",
                                      width: constraints.maxWidth,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Relationship type",
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
                              "Job",
                              style: TextStyle(
                                color: AppColor.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
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
