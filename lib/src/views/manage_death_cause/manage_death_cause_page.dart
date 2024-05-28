import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/cause_of_death.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/death_causes_table.dart';
import 'bloc/manage_death_cause_bloc.dart';
import 'views/dialog_update_death_cause.dart';

class ManageDeathCausePage extends StatelessWidget {
  const ManageDeathCausePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageDeathCauseBloc(
        RepositoryProvider.of<AllRepository>(context).deathCauseRepository
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildAdd(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: const BackButton(color: AppColor.primary,),
          backgroundColor: Colors.transparent,
          title: Text("Death Causes", style: AppTextStyles.header,),
        ),
        body: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
          ),
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 20 : 0),
          child: const DeathCausesTable()
        ),
      ),
    );
  }

  Widget _buildAdd() {
    return BlocConsumer<ManageDeathCauseBloc, ManageDeathCauseState>(
      listener: (context, state) {
        if (state is ErrorUpdateManageDeathCauseState) {
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
                  return DialogUpdateDeathCause(
                    list: state.items,
                  );
                },
              );
              if (data != null && data is CauseOfDeath) {
                final added = data;
                debugPrint("$added");
                // ignore: use_build_context_synchronously
                context.read<ManageDeathCauseBloc>()
                    .add(AddDeathCauseEvent(added));
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
