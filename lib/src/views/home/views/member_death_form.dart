import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/models/death.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/views/common/day_picker.dart';
import 'package:famitree/src/views/common/death_cause_filter.dart';
import 'package:famitree/src/views/common/keyboard_dismiss.dart';
import 'package:famitree/src/views/common/member_filter.dart';
import 'package:famitree/src/views/common/place_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc.dart';

class MemberDeathForm extends StatefulWidget {
  const MemberDeathForm({
    super.key, this.selectedMember, this.death, 
  });

  final Member? selectedMember;
  final Death? death;

  @override
  State<MemberDeathForm> createState() => _MemberDeathFormState();
}

class _MemberDeathFormState extends State<MemberDeathForm> {
  String? generalError;

  CauseOfDeath? cause;
  Member? selectedMember;
  late ValueNotifier<DateTime> date;
  Place? place;

  @override
  void initState() {
    super.initState();
    selectedMember = widget.selectedMember;
    date = ValueNotifier(widget.death?.time ?? DateTime.now());
    cause = widget.death?.cause;
    place = widget.death?.place;
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

    if (cause == null) {
      setState(() {
        generalError = "Choose cause";
      });
      return;
    }

    if (place == null) {
      setState(() {
        generalError = "Choose place";
      });
      return;
    }

    Death newItem = Death(
      cause: cause!, 
      time: date.value,
      place: place!
    );

    BlocProvider.of<HomePageBloc>(context)
        .add(AddDeathEvent(selectedMember!, newItem));
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
                                  "Add ${widget.selectedMember!.name}'s loss" :
                                  "Add member Loss",
                                style: const TextStyle(
                                  color: AppColor.text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            if (widget.selectedMember == null) ...[
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
                            const SizedBox(width: 10),
                            const Text(
                              "Cause:",
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
                                    return DeathCauseFilter(
                                      allValues: state.deathCauses,
                                      onSelected: (type) {
                                        cause = type;
                                      },
                                      initText: cause?.name ?? "",
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
                              "Place:",
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
                                    return PlaceFilter(
                                      allValues: state.places,
                                      onSelected: (type) {
                                        place = type;
                                      },
                                      initText: place?.name ?? "",
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
