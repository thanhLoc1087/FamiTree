import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/common/yes_no_dialog.dart';
import 'package:famitree/src/views/manage_job/views/dialog_update_job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/manage_job_bloc.dart';

class JobsTable extends StatelessWidget {
  const JobsTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageJobBloc(
          RepositoryProvider.of<AllRepository>(context).jobRepository),
      child: BlocBuilder<ManageJobBloc, ManageJobState>(
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
                  for (var i = 0; i < state.jobs.length; i++)
                    myRow(context, state.jobs[i], i + 1, state),
                ]),
          );
        },
      ),
    );
  }

  DataRow myRow(
    BuildContext context,
    Job place,
    int order,
    ManageJobState state,
  ) {
    return DataRow(
        onSelectChanged: (value) {
          if (value == true) {
            _update(context, place, state);
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
              place.name,
              style: AppTextStyles.body,
            ),
          ),
          DataCell(
            Text(
              place.description,
              style: AppTextStyles.body,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          DataCell(
            Center(
              child: Text(
                cvToString(place.quantity),
                style: AppTextStyles.body,
              ),
            ),
          ),
          DataCell(
            Center(
              child: !place.deleted
                ? InkWell(
                    onTap: () {
                      _deleteService(context, place);
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
                      _restoreService(context, place);
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
    Job item,
    ManageJobState state,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return DialogUpdateJob(
          job: item,
          list: state.jobs,
        );
      },
    ).then((data) {
      if (data != null && data is Job) {
        final updated = data;
        context.read<ManageJobBloc>().add(UpdateJobEvent(updated));
      }
    });
  }

  /// Show dialog confirm delete service
  void _deleteService(
    BuildContext context,
    Job job,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Delete this jobs",
          content:
              "Are your sure you want to delete this jobs?\nDeleted jobss cannot be used for other related features.",
        );
      },
    ).then((value) {
      if (value) {
        context.read<ManageJobBloc>().add(
              DeleteJobEvent(
                job,
              ),
            );
      }
    });
  }

  /// Show dialog confirm restore service
  void _restoreService(
    BuildContext context,
    Job job,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Restore deleted job",
          content: "Are you sure you want to restore this job?",
        );
      },
    ).then((value) {
      if (value) {
        context.read<ManageJobBloc>().add(
              RestoreJobEvent(
                job,
              ),
            );
      }
    });
  }
}
