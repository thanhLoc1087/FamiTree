import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/common/yes_no_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/manage_relationship_type_bloc.dart';
import 'dialog_update_relationship_type.dart';

class RelationshipTypesTable extends StatelessWidget {
  const RelationshipTypesTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageRelationshipTypeBloc(
          RepositoryProvider.of<AllRepository>(context).relationshipTypeRepository),
      child: BlocBuilder<ManageRelationshipTypeBloc, ManageRelationshipTypeState>(
        builder: (context, state) {
          debugPrint("${state.items}");
          return DataTable(
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
              ]);
        },
      ),
    );
  }

  DataRow myRow(
    BuildContext context,
    RelationshipType item,
    int order,
    ManageRelationshipTypeState state,
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
    RelationshipType item,
    ManageRelationshipTypeState state,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return DialogUpdateRelationshipType(
          item: item,
          list: state.items,
        );
      },
    ).then((data) {
      if (data != null && data is RelationshipType) {
        final updated = data;
        context.read<ManageRelationshipTypeBloc>().add(UpdateRelationshipTypeEvent(updated));
      }
    });
  }

  /// Show dialog confirm delete service
  void _deleteService(
    BuildContext context,
    RelationshipType item,
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
        context.read<ManageRelationshipTypeBloc>().add(
              DeleteRelationshipTypeEvent(
                item,
              ),
            );
      }
    });
  }

  /// Show dialog confirm restore service
  void _restoreService(
    BuildContext context,
    RelationshipType item,
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
        context.read<ManageRelationshipTypeBloc>().add(
              RestoreRelationshipTypeEvent(
                item,
              ),
            );
      }
    });
  }
}
