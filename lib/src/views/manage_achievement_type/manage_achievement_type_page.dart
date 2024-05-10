import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/achievement_type.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/achievement_types_table.dart';
import 'bloc/manage_achievement_type_bloc.dart';
import 'views/dialog_update_achievement_type.dart';

class ManageAchievementTypePage extends StatelessWidget {
  const ManageAchievementTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageAchievementTypeBloc(
        RepositoryProvider.of<AllRepository>(context).achievementTypeRepository
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildAdd(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Achievement Types"),
          automaticallyImplyLeading: false
        ),
        body: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
          ),
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 20 : 0),
          child: const AchievementTypesTable()
        ),
      ),
    );
  }

  Widget _buildAdd() {
    return BlocConsumer<ManageAchievementTypeBloc, ManageAchievementTypeState>(
      listener: (context, state) {
        if (state is ErrorUpdateManageAchievementTypeState) {
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
                  return DialogUpdateAchievementType(
                    list: state.items,
                  );
                },
              );
              if (data != null && data is AchievementType) {
                final added = data;
                debugPrint("$added");
                // ignore: use_build_context_synchronously
                context.read<ManageAchievementTypeBloc>()
                    .add(AddAchievementTypeEvent(added));
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
