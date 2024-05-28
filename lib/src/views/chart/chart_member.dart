import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartMembers extends StatelessWidget {
  const ChartMembers({super.key, required this.members, required this.firstMember,});
  final List<Member> members;
  final Member firstMember;

  @override
  Widget build(BuildContext context) {
    int gen = 1;
    Map<String, int> mapGen = {
      firstMember.id: gen
    };

    void _calGen(int gen, Member member) {
      mapGen.addAll({
        member.id: gen
      });
      final spouse = member.spouse;
      if (spouse != null) {
        mapGen.addAll({
          spouse.id: gen
        });
      }
      member.pastSpouses?.forEach((element) {
        mapGen.addAll({
          element.id: gen
        });
      });
    }

    void dfs(Member member) {
      _calGen(gen, member);

      gen++;
      // Recursively process each child
      for (var child in member.children ?? []) {
        dfs(child);
        gen--;
      }
    }

    dfs(firstMember);
    members.sort((a, b) => (mapGen[a.id] ?? 0).compareTo((mapGen[b.id] ?? 0)));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 24
        ),
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: ColumnField(name: 'STT')),
            DataColumn(label: ColumnField(name: 'Name')),
            DataColumn(label: ColumnField(name: 'Birthday')),
            DataColumn(label: ColumnField(name: 'Gen')),
            DataColumn(label: ColumnField(name: 'Passed')),
          ],
          rows: [
            for (int i = 0; i < members.length; i++) 
              DataRow(
                onSelectChanged: (value) {
                  BlocProvider.of<HomePageBloc>(context).add(SelectMemberHomeEvent(members[i]));
                  Navigator.of(context).popAndPushNamed(AppRouter.memberProfile);
                },
                cells: [
                  DataCell(Text(cvToString(i + 1))),
                  DataCell(Text(members[i].name)),
                  DataCell(Text(members[i].birthday.toDMYFormat())),
                  DataCell(Text(cvToString(mapGen[members[i].id]))),
                  DataCell(Text(members[i].isDead ? "Yes" : "No")),
                ]
              ),
          ]
        ),
      ),
    );
  }
}