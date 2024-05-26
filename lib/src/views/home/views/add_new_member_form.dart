import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/models/relationship.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/common/checkbox.dart';
import 'package:famitree/src/views/common/day_picker.dart';
import 'package:famitree/src/views/common/job_filter.dart';
import 'package:famitree/src/views/common/keyboard_dismiss.dart';
import 'package:famitree/src/views/common/member_filter.dart';
import 'package:famitree/src/views/common/place_filter.dart';
import 'package:famitree/src/views/common/relationship_type_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc.dart';

class AddMemberForm extends StatefulWidget {
  const AddMemberForm({
    super.key,
  });

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {

  String? errorName;
  String? errorMemberName;
  String? errorCode;
  String? generalError;

  bool isMale = false;

  final _memberNameController = TextEditingController();
  Place? birthPlace;
  Job? job;
  RelationshipType? relationshipType;
  Member? relateTo;
  late ValueNotifier<DateTime> birthday;
  late ValueNotifier<DateTime> relateDate;

  final _memberNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    birthday = ValueNotifier(DateTime.now());
    relateDate = ValueNotifier(DateTime.now());
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<HomePageBloc>(context).add(const LoadDataHomeEvent());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _memberNameController.dispose();

    _memberNameFocus.dispose();

    super.dispose();
  }

  _submit() async {
    String memberName = _memberNameController.text.trim();

    if (memberName.isEmpty) {
      setState(() {
        errorMemberName = "Your member name cannot be empty!";
      });
      return;
    } 
    if (birthPlace == null) {
      setState(() {
        generalError = "Choose birthplace";
      });
      return;
    } 
    if (job == null) {
      setState(() {
        generalError = "Choose job";
      });
      return;
    }

    Member newMember = Member(
      id: '',
      name: memberName,
      homeland: birthPlace!,
      treeCode: CurrentUser().user.treeCode!,
      birthday: birthday.value, 
      job: job!,
      isMale: isMale,
      relationship: Relationship(
        type: relationshipType!, 
        member: relateTo!, 
        time: relateDate.value
      ),
    );

    BlocProvider.of<HomePageBloc>(context)
        .add(AddMemberEvent(newMember));
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
                            const Center(
                              child: Text(
                                "Add family member",
                                style: TextStyle(
                                  color: AppColor.text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Name",
                              style: TextStyle(
                                color: AppColor.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _memberNameController,
                              focusNode: _memberNameFocus,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter member name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _memberNameController.text = "";
                                  },
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: AppColor.interactive,
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: const Icon(
                                      Icons.clear,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorText: errorMemberName,
                              ),
                              onChanged: (value) {
                                if (value.trim().isNotEmpty &&
                                    errorMemberName != null) {
                                  setState(() {
                                    errorMemberName = null;
                                  });
                                }
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                color: AppColor.text,
                              ),
                              maxLength: 50,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Homeland",
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
                                      onSelected: (place) {
                                        birthPlace = place;
                                      },
                                      initText: birthPlace?.name ?? "",
                                      width: constraints.maxWidth,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Birthday",
                                      style: TextStyle(
                                        color: AppColor.text,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ValueListenableBuilder(
                                      valueListenable: birthday,
                                      builder: (context, value, child) => DayPicker(
                                        initTime: value,
                                        onChanged: (p0) {
                                          if (p0 != null) {
                                            birthday.value = p0;
                                          }
                                        },
                                      ),
                                    ),
                                  ],)
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Gender",
                                        style: TextStyle(
                                          color: AppColor.text,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      CheckBoxSection(
                                        text: "Male", 
                                        onChanged: (value) {
                                          isMale = value;
                                        }, 
                                        initValue: isMale
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
                            const SizedBox(height: 10),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return BlocBuilder<HomePageBloc, HomePageState>(
                                  builder: (context, state) {
                                    return JobFilter(
                                      allValues: state.jobs,
                                      onSelected: (selected) {
                                        job = selected;
                                      },
                                      initText: job?.name ?? "",
                                      width: constraints.maxWidth,
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Relates to",
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
                                              return MemberFilter(
                                                allValues: state.members,
                                                onSelected: (member) {
                                                  relateTo = member;
                                                },
                                                initText: relateTo?.name ?? "",
                                                width: constraints.maxWidth,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                  ],),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
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
                                        valueListenable: relateDate,
                                        builder: (context, value, child) => DayPicker(
                                          initTime: value,
                                          onChanged: (p0) {
                                            if (p0 != null) {
                                              relateDate.value = p0;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
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
                                    return RelationshipTypeFilter(
                                      allValues: state.relationshipTypes,
                                      onSelected: (type) {
                                        relationshipType = type;
                                      },
                                      initText: relationshipType?.name ?? "",
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
