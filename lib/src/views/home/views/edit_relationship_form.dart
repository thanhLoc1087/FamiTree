import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/relationship.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/views/common/day_picker.dart';
import 'package:famitree/src/views/common/keyboard_dismiss.dart';
import 'package:famitree/src/views/common/member_filter.dart';
import 'package:famitree/src/views/common/relationship_type_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_page_bloc.dart';

class EditRelationshipForm extends StatefulWidget {
  const EditRelationshipForm({
    super.key, 
    required this.member,
    required this.relationship,
  });

  final Member member;
  final Relationship relationship;

  @override
  State<EditRelationshipForm> createState() => _EditRelationshipFormState();
}

class _EditRelationshipFormState extends State<EditRelationshipForm> {
  String? generalError;

  RelationshipType? relationshipType;
  Member? relatesTo;
  late ValueNotifier<DateTime> relateDate;

  @override
  void initState() {
    super.initState();
    relateDate = ValueNotifier(widget.relationship.time);
    relatesTo = widget.relationship.member;
    relationshipType = widget.relationship.type;
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
    if (relationshipType == null || relatesTo == null) {
      setState(() {
        generalError = "Choose relationship";
      });
      return;
    }
    Member newMember = widget.member.copyWith(
      relationship: Relationship(
        type: relationshipType!,
        member: relatesTo!, 
        time: relateDate.value
      )
    );
    BlocProvider.of<HomePageBloc>(context)
      .add(UpdateMemberEvent(newMember));
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
                            const Center(
                              child: Text(
                                "Edit member relationship",
                                style: TextStyle(
                                  color: AppColor.text,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
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
                                                allValues: state.members..retainWhere((element) => 
                                                  (element.relationship == null || 
                                                  element.relationship!.type.id != 'spouse') &&
                                                  !(element.id == widget.member.id)
                                                ),
                                                onSelected: (member) {
                                                  relatesTo = member;
                                                },
                                                initText: relatesTo?.name ?? "",
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
