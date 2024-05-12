import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/jobs_table.dart';
import 'bloc/manage_job_bloc.dart';
import 'views/dialog_update_job.dart';

class ManageJobPage extends StatelessWidget {
  const ManageJobPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageJobBloc(
        RepositoryProvider.of<AllRepository>(context).jobRepository
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildAddPlace(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Jobs"),
        ),
        body: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
          ),
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 20 : 0),
          child: const JobsTable()
        ),
      ),
    );
  }

  Widget _buildAddPlace() {
    return BlocConsumer<ManageJobBloc, ManageJobState>(
      listener: (context, state) {
        if (state is ErrorUpdateManageJobState) {
          Toasty.show(state.errorMessage, type: ToastType.error);
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.accent,
              fixedSize: Size(MediaQuery.sizeOf(context).width, 50),
            ),
            onPressed: () async {
              final data = await showDialog(
                context: context,
                builder: (context) {
                  return DialogUpdateJob(
                    list: state.jobs,
                  );
                },
              );
              if (data != null && data is Job) {
                final added = data;
                debugPrint("$added");
                // ignore: use_build_context_synchronously
                context.read<ManageJobBloc>()
                    .add(AddJobEvent(added));
              }
            },
            child: const Text(
              "Add New",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}
