import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/common/checkbox.dart';
import 'package:famitree/src/views/common/day_picker.dart';
import 'package:famitree/src/views/common/keyboard_dismiss.dart';
import 'package:famitree/src/views/common/place_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/job_filter.dart';
import '../bloc/home_page_bloc.dart';

class CreateTreeForm extends StatefulWidget {
  const CreateTreeForm({
    super.key,
  });

  @override
  State<CreateTreeForm> createState() => _CreateTreeFormState();
}

class _CreateTreeFormState extends State<CreateTreeForm> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _viewCodeController = TextEditingController();

  final _nameFocus = FocusNode();
  final _codeFocus = FocusNode();
  final _viewCodeFocus = FocusNode();

  String? errorName;
  String? errorMemberName;
  String? errorCode;
  String? errorViewCode;
  String? generalError;

  final _memberNameController = TextEditingController();
  Place? birthPlace;
  Job? job;
  late ValueNotifier<DateTime> birthday;

  bool isMale = false;

  final _memberNameFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    birthday = ValueNotifier(DateTime.now());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _viewCodeController.dispose();
    _memberNameController.dispose();

    _nameFocus.dispose();
    _codeFocus.dispose();
    _memberNameFocus.dispose();

    super.dispose();
  }

  _submit() {
    String name = _nameController.text.trim();
    String code = _codeController.text.trim();
    String viewCode = _viewCodeController.text.trim();
    String memberName = _memberNameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorName = "The name of your tree cannot be empty";
      });
      return;
    }
    if (code.isEmpty) {
      setState(() {
        errorCode = "The your tree code cannot be empty!";
      });
      return;
    }
    if (memberName.isEmpty) {
      setState(() {
        errorMemberName = "Your membername cannot be empty!";
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

    FamilyTree updated = FamilyTree(
        id: '',
        name: name,
        treeCode: code,
        viewCode: viewCode,
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
        editors:[CurrentUser().user.uid]
      );

    Member newMember = Member(
        id: '',
        name: memberName,
        homeland: birthPlace!,
        job: job!,
        treeCode: code,
        birthday: birthday.value,
        isMale: isMale
      );

    BlocProvider.of<HomePageBloc>(context)
        .add(AddTreeHomeEvent(updated, newMember));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomePageBloc, HomePageState>(
      listener: (context, state) {
        if (state is CompleteUpdateHomePageState) {
          Toasty.show("Create tree successfully!", context: context);
          Navigator.of(context).pop();
          BlocProvider.of<HomePageBloc>(context).add(const LoadDataHomeEvent());
        } else if (state is ErrorUpdateHomePageState) {
          Toasty.show(state.errorMessage, context: context);
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
                                "Create your Tree",
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
                              controller: _nameController,
                              focusNode: _nameFocus,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText: "Enter tree name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _nameController.text = "";
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
                                errorText: errorName,
                              ),
                              onChanged: (value) {
                                if (value.trim().isNotEmpty &&
                                    errorName != null) {
                                  setState(() {
                                    errorName = null;
                                  });
                                }
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                _codeFocus.nextFocus();
                              },
                              style: const TextStyle(
                                color: AppColor.text,
                              ),
                              maxLength: 50,
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Tree Code",
                              style: TextStyle(
                                color: AppColor.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _codeController,
                              focusNode: _codeFocus,
                              autofocus: true,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText:
                                    "Others can join your tree with Tree Code",
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: AppColor.text),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _codeController.text = "";
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
                                errorText: errorCode,
                              ),
                              onChanged: (value) {
                                if (value.trim().isNotEmpty &&
                                    errorCode != null) {
                                  setState(() {
                                    errorCode = null;
                                  });
                                }
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                _viewCodeFocus.nextFocus();
                              },
                              style: const TextStyle(
                                color: AppColor.text,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              "Tree View Code",
                              style: TextStyle(
                                color: AppColor.text,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _viewCodeController,
                              focusNode: _viewCodeFocus,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                counterText: "",
                                hintText:
                                    "You can share your tree with others with Tree View Code",
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: AppColor.text),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _viewCodeController.text = "";
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
                                errorText: errorViewCode,
                              ),
                              onChanged: (value) {
                                if (value.trim().isNotEmpty &&
                                    errorViewCode != null) {
                                  setState(() {
                                    errorViewCode = null;
                                  });
                                }
                              },
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (value) {
                                _memberNameFocus.nextFocus();
                              },
                              style: const TextStyle(
                                color: AppColor.text,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text(
                                "First family member",
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
                                    ],),
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
