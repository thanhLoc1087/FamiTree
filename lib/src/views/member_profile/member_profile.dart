import 'package:cached_network_image/cached_network_image.dart';
import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:famitree/src/views/common/yes_no_dialog.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:famitree/src/views/home/views/add_new_member_form.dart';
import 'package:famitree/src/views/home/views/edit_relationship_form.dart';
import 'package:famitree/src/views/home/views/member_death_form.dart';
import 'package:famitree/src/views/member_profile/views/achievement_table.dart';
import 'package:famitree/src/views/member_profile/views/member_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberProbilePage extends StatelessWidget {
  const MemberProbilePage({super.key, required this.readOnly});

  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.background,
      appBar: AppBar(
        leading: const BackButton(
          color: AppColor.text,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<HomePageBloc, HomePageState>(
            builder: (context, state) {
              if (state.selectedMember == null) {
                return const Center(
                  child: Text('Đã có lỗi xảy ra.\nKhông lấy được dữ liệu thành viên.'),
                );
              }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      state.selectedMember!.image?.isNotEmpty == true
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  CachedNetworkImageProvider(state.selectedMember!.image!),
                            )
                          : const CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  AssetImage(AppImage.defaultProfile),
                            ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.selectedMember!.name,
                              style: const TextStyle(
                                color: AppColor.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.body,
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Birthday:\t',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: state.selectedMember!.birthday.toDMYFormat()),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: AppTextStyles.body,
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Gender:\t',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: state.selectedMember!.isMale ? "Male" : "Female"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!readOnly)
                      IconButton(
                        onPressed: () async {
                          final data = await showDialog(
                            context: context,
                            builder: (context) {
                              return AddMemberForm(
                                member: state.selectedMember!,
                              );
                            },
                          );
                          if (data != null) {
                            debugPrint(data);
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppColor.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.body,
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Homeland:\t',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                '${state.selectedMember!.homeland.name} - ${state.selectedMember!.homeland.address}'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.body,
                      children: <TextSpan>[
                        const TextSpan(
                            text: 'Job:\t',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                '${state.selectedMember!.job.name} - ${state.selectedMember!.job.description}'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Divider(),
                  const Text('Relationships:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (state.selectedMember!.relationship?.type.id == 'child') ...[
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Parents:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    MembersTable(
                      members: [
                        ...(state.selectedMember!.parents ?? []),
                      ],
                      allowEdit: false,
                    )
                  ],
                  Row(
                    children: [
                      const Expanded(
                          child: Text('Spouse:',
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      if (state.selectedMember!.spouse != null && !readOnly)
                      IconButton(
                        onPressed: () async {
                          final data = await showDialog(
                            context: context,
                            builder: (context) {
                              return EditRelationshipForm(
                                member: state.selectedMember!,
                                relationship: state.selectedMember!.relationship!,
                              );
                            },
                          );
                          if (data != null) {
                            debugPrint(data);
                          }
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: AppColor.text,
                        ),
                      ),
                    ],
                  ),
                  if (state.selectedMember!.spouse != null) ...[
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.body,
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Member:\t',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  '${state.selectedMember!.spouse!.name} (${state.selectedMember!.spouse!.birthday.toDMYFormat()})'),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: AppTextStyles.body,
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'Date:\t',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: state.selectedMember!.spouse!.relationship?.time
                                    .toDMYFormat() ??
                                state.selectedMember!.relationship?.time.toDMYFormat(),
                          ),
                        ],
                      ),
                    ),
                  ] else
                    const Text('None'),
                  if (state.selectedMember!.pastSpouses?.isNotEmpty == true) ...[
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('Past spouses:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    MembersTable(
                      members: state.selectedMember!.pastSpouses!,
                      allowEdit: false,
                    )
                  ],
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Children:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (state.selectedMember!.children?.isNotEmpty == true)
                    MembersTable(
                      members: state.selectedMember!.children!,
                      allowEdit: false,
                    )
                  else
                    const Text('None'),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const Text('Achievements:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  AchievementsTable(
                    achievements: state.selectedMember!.achievements,
                    allowEdit: !readOnly,
                  ),
                  const Divider(),
                  const Text('Estranged:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  if (state.selectedMember!.isDead)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.body,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Date:\t',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: state.selectedMember!.death!.time.toDMYFormat(),
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.body,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Cause:\t',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: state.selectedMember!.death!.cause.name,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.body,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Detail:\t',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: state.selectedMember!.death!.cause.description,
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: AppTextStyles.body,
                                  children: <TextSpan>[
                                    const TextSpan(
                                        text: 'Place:\t',
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: '${state.selectedMember!.death!.place.name} (${state.selectedMember!.death!.place.address})',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!readOnly)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async {
                                final data = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return MemberDeathForm(
                                      selectedMember: state.selectedMember!,
                                      death: state.selectedMember?.death,
                                    );
                                  },
                                );
                                if (data != null) {
                                  debugPrint(data);
                                }
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: AppColor.text,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const YesNoDialog(
                                      title: "Delete this achievement",
                                      content:
                                          "Are your sure you want to delete this achievement?",
                                    );
                                  },
                                ).then((value) {
                                  if (value && state.selectedMember != null) {
                                    context.read<HomePageBloc>().add(
                                      DeleteDeathEvent(
                                        state.selectedMember!
                                      ),
                                    );
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.delete_outlined,
                                color: AppColor.danger,
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  else if (!readOnly)
                    ElevatedButton(
                      onPressed: () async {
                        final data = await showDialog(
                          context: context,
                          builder: (context) {
                            return MemberDeathForm(
                              selectedMember: state.selectedMember!,
                            );
                          },
                        );
                        if (data != null) {
                          debugPrint(data);
                        }
                      },
                      child: const Text('+ Add')),
                  const SizedBox(height: 80,)
                ],
              ),
            );
          }
        )),
    );
  }
}
