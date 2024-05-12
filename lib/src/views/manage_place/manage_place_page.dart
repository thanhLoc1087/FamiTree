import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/global/global_data.dart';
import 'package:famitree/src/core/utils/toasty.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/dialog_update_place.dart';
import 'views/places_table.dart';
import 'bloc/manage_place_bloc.dart';

class ManagePlacePage extends StatelessWidget {
  const ManagePlacePage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("${GlobalData().places}");
    return BlocProvider(
      create: (context) => ManagePlaceBloc(
        RepositoryProvider.of<AllRepository>(context).placeRepository
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildAddPlace(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const Text("Places"),
        ),
        body: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.sizeOf(context).width,
          ),
          padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 20 : 0),
          child: const PlacesTable()
        ),
      ),
    );
  }

  Widget _buildAddPlace() {
    return BlocConsumer<ManagePlaceBloc, ManagePlaceState>(
      listener: (context, state) {
        if (state is ErrorUpdateManagePlaceState) {
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
                  return DialogUpdatePlace(
                    list: state.places,
                  );
                },
              );
              if (data != null && data is Place) {
                final added = data;
                debugPrint("$added");
                // ignore: use_build_context_synchronously
                context.read<ManagePlaceBloc>()
                    .add(AddPlaceEvent(added));
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
