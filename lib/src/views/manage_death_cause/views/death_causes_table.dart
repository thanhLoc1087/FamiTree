import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/common/yes_no_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/manage_death_cause_bloc.dart';
import 'dialog_update_death_cause.dart';

class DeathCausesTable extends StatelessWidget {
  const DeathCausesTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageDeathCauseBloc(
          RepositoryProvider.of<AllRepository>(context).deathCauseRepository),
      child: BlocBuilder<ManageDeathCauseBloc, ManageDeathCauseState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                horizontalMargin: 10,
                columnSpacing: 20,
                dataRowMinHeight: 45,
                dataRowMaxHeight: 45,
                border: TableBorder.all(width: 0.3, color: Colors.black26),
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => AppColor.background),
                headingRowHeight: 50,
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: ColumnField(name: "ID")),
                  DataColumn(label: ColumnField(name: "Name")),
                  DataColumn(label: ColumnField(name: "Description")),
                  DataColumn(label: ColumnField(name: "Quantity")),
                  DataColumn(label: ColumnField(name: "Delete")),
                ],
                rows: [
                  for (var i = 0; i < state.items.length; i++)
                    myRow(context, state.items[i], i + 1, state),
                ]),
          );
        },
      ),
    );
  }

  DataRow myRow(
    BuildContext context,
    CauseOfDeath item,
    int order,
    ManageDeathCauseState state,
  ) {
    return DataRow(
        onSelectChanged: (value) {
          if (value == true) {
            _update(context, item, state);
          }
        },
        cells: [
          DataCell(
            Center(
              child: Text(
                cvToString(order),
                style: AppTextStyles.body,
              ),
            ),
          ),
          DataCell(
            Text(
              item.name,
              style: AppTextStyles.body,
            ),
          ),
          DataCell(
            Text(
              item.description,
              style: AppTextStyles.body,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          DataCell(
            Center(
              child: Text(
                cvToString(item.quantity),
                style: AppTextStyles.body,
              ),
            ),
          ),
          DataCell(
            Center(
              child: !item.deleted
                ? InkWell(
                    onTap: () {
                      _deleteService(context, item);
                    },
                    child: Container(
                      height: 45,
                      constraints: const BoxConstraints(minWidth: 200),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColor.danger,
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      _restoreService(context, item);
                    },
                    child: Container(
                      height: 45,
                      constraints: const BoxConstraints(minWidth: 200),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.delete_outline,
                        color: AppColor.safe,
                      ),
                    ),
                  )
              )),
        ]);
  }

  /// Show dialog update service
  void _update(
    BuildContext context,
    CauseOfDeath item,
    ManageDeathCauseState state,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return DialogUpdateDeathCause(
          item: item,
          list: state.items,
        );
      },
    ).then((data) {
      if (data != null && data is CauseOfDeath) {
        final updated = data;
        context.read<ManageDeathCauseBloc>().add(UpdateDeathCauseEvent(updated));
      }
    });
  }

  /// Show dialog confirm delete service
  void _deleteService(
    BuildContext context,
    CauseOfDeath item,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Delete this item",
          content:
              "Are your sure you want to delete this item?\nDeleted items cannot be used for other related features.",
        );
      },
    ).then((value) {
      if (value) {
        context.read<ManageDeathCauseBloc>().add(
              DeleteDeathCauseEvent(
                item,
              ),
            );
      }
    });
  }

  /// Show dialog confirm restore service
  void _restoreService(
    BuildContext context,
    CauseOfDeath item,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Restore deleted item",
          content: "Are you sure you want to restore this item?",
        );
      },
    ).then((value) {
      if (value) {
        context.read<ManageDeathCauseBloc>().add(
              RestoreDeathCauseEvent(
                item,
              ),
            );
      }
    });
  }
}
