import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/relationship_type.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/manage_relationship_type_bloc.dart';
import 'views/dialog_update_relationship_type.dart';
import 'views/relationship_types_table.dart';

class ManageRelationshipTypePage extends StatelessWidget {
  const ManageRelationshipTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageRelationshipTypeBloc(
        RepositoryProvider.of<AllRepository>(context).relationshipTypeRepository
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildAdd(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("Relationship Types", style: AppTextStyles.header,),
          leading: const BackButton(color: AppColor.primary,),
        ),
        body: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
          ),
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 20 : 0),
          child: const RelationshipTypesTable()
        ),
      ),
    );
  }

  Widget _buildAdd() {
    return BlocConsumer<ManageRelationshipTypeBloc, ManageRelationshipTypeState>(
      listener: (context, state) {
        if (state is ErrorUpdateManageRelationshipTypeState) {
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
                  return DialogUpdateRelationshipType(
                    list: state.items,
                  );
                },
              );
              if (data != null && data is RelationshipType) {
                final added = data;
                debugPrint("$added");
                // ignore: use_build_context_synchronously
                context.read<ManageRelationshipTypeBloc>()
                    .add(AddRelationshipTypeEvent(added));
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
