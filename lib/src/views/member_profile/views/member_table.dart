import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:famitree/src/views/home/views/edit_relationship_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MembersTable extends StatelessWidget {
  const MembersTable({super.key, required this.members, required this.allowEdit});
  final List<Member> members;
  final bool allowEdit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 24
        ),
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
            const DataColumn(label: ColumnField(name: 'STT')),
            const DataColumn(label: ColumnField(name: 'Name')),
            const DataColumn(label: ColumnField(name: 'Birthday')),
            if (allowEdit)
              const DataColumn(label: ColumnField(name: 'Edit')),
          ],
          rows: [
            for (int i = 0; i < members.length; i++) 
              DataRow(
                onSelectChanged: (value) {
                  if (value == true) {
                    BlocProvider.of<HomePageBloc>(context).add(SelectMemberHomeEvent(members[i]));
                    Navigator.of(context).popAndPushNamed(AppRouter.memberProfile);
                  }
                },
                cells: [
                  DataCell(Text(cvToString(i + 1))),
                  DataCell(Text(members[i].name)),
                  DataCell(Text(members[i].birthday.toDMYFormat())),
                  if (allowEdit)
                  DataCell(
                    IconButton(
                      onPressed: () async {
                        final data = await showDialog(
                          context: context,
                          builder: (context) {
                            return EditRelationshipForm(
                              member: members[i], 
                              relationship: members[i].relationship!,
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
                    )
                  ),
                ]
              ),
          ]
        ),
      ),
    );
  }
}