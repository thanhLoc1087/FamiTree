import 'package:famitree/src/core/extensions/datetime_ext.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/death.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:flutter/material.dart';

class ChartDeath extends StatelessWidget {
  const ChartDeath({super.key, required this.mapMemberDeath});

  final Map<Death, String> mapMemberDeath;

  @override
  Widget build(BuildContext context) {
    int i=0;
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
            DataColumn(label: ColumnField(name: 'Cause')),
            DataColumn(label: ColumnField(name: 'Place')),
            DataColumn(label: ColumnField(name: 'Time')),
          ],
          rows: [
            
            for (var key in mapMemberDeath.keys) 
              DataRow(
                cells: [
                  DataCell(Text(cvToString(++i))),
                  DataCell(Text(mapMemberDeath[key]!)),
                  DataCell(Text(key.cause.name)),
                  DataCell(Text(key.place.name)),
                  DataCell(Text(key.time.toDMYFormat())),
                ]
              ),
          ]
        ),
      ),
    );
  }
}