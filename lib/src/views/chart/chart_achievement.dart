import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:famitree/src/views/home/views/edit_achievement_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartAchievement extends StatelessWidget {
  const ChartAchievement(
      {super.key, required this.achievements, required this.canAdd});
  final Map<Achievement, String> achievements;
  final bool canAdd;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (achievements.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 24),
                  child: DataTable(columns: const [
                    DataColumn(label: ColumnField(name: 'STT')),
                    DataColumn(label: ColumnField(name: 'Name')),
                    DataColumn(label: ColumnField(name: 'Achievement')),
                    DataColumn(label: ColumnField(name: 'Time')),
                  ], rows: [
                    for (int i = 0; i < achievements.keys.length; i++)
                      DataRow(cells: [
                        DataCell(Text(cvToString(i + 1))),
                        DataCell(Text(achievements[achievements.keys.elementAt(i)] ?? 'No data')),
                        DataCell(Text(achievements.keys.elementAt(i).type.name)),
                        DataCell(Text(achievements.keys.elementAt(i).time.toDMYFormat())),
                      ]),
                  ]),
                ),
                if (canAdd)
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
