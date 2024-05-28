import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/common/yes_no_dialog.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:famitree/src/views/home/views/edit_achievement_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsTable extends StatelessWidget {
  const AchievementsTable(
      {super.key, required this.achievements, required this.allowEdit});
  final List<Achievement> achievements;
  final bool allowEdit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          if (state.selectedMember == null) {
            return const Center(
              child: Text('Đã có lỗi xảy ra.\nKhông lấy được dữ liệu thành viên.'),
            );
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (achievements.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 24),
                  child: DataTable(columns: [
                    const DataColumn(label: ColumnField(name: 'STT')),
                    const DataColumn(label: ColumnField(name: 'Name')),
                    const DataColumn(label: ColumnField(name: 'Date')),
                    if (allowEdit)...[
                      const DataColumn(label: ColumnField(name: 'Edit')),
                      const DataColumn(label: ColumnField(name: 'Delete')),
                    ],
                  ], rows: [
                    for (int i = 0; i < achievements.length; i++)
                      DataRow(cells: [
                        DataCell(Text(cvToString(i + 1))),
                        DataCell(Text(achievements[i].type.name)),
                        DataCell(Text(achievements[i].time.toDMYFormat())),
                        if (allowEdit) ...[
                          DataCell(IconButton(
                            onPressed: () async {
                              final data = await showDialog(
                                context: context,
                                builder: (context) {
                                  return EditAchievementForm(
                                    member: state.selectedMember!,
                                    achievement: achievements[i],
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
                          )),
                          DataCell(IconButton(
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
                                    DeleteAchievementEvent(
                                      state.selectedMember!, achievements[i]
                                    ),
                                  );
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.delete_outlined,
                              color: AppColor.danger,
                            ),
                          )),
                        ]
                      ]),
                  ]),
                ),
                if (allowEdit)
              ElevatedButton(
                  onPressed: () async {
                    final data = await showDialog(
                      context: context,
                      builder: (context) {
                        return EditAchievementForm(
                          member: state.selectedMember!,
                          achievement: null,
                        );
                      },
                    );
                    if (data != null) {
                      debugPrint(data);
                    }
                  },
                  child: const Text('+ Add')),
            ],
          );
        }
      ),
    );
  }
}
