import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/core/utils/converter.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/data/repositories/all_repository.dart';
import 'package:famitree/src/views/common/column_field.dart';
import 'package:famitree/src/views/common/yes_no_dialog.dart';
import 'package:famitree/src/views/manage_place/bloc/manage_place_bloc.dart';
import 'package:famitree/src/views/manage_place/views/dialog_update_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlacesTable extends StatelessWidget {
  const PlacesTable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManagePlaceBloc(
          RepositoryProvider.of<AllRepository>(context).placeRepository),
      child: BlocBuilder<ManagePlaceBloc, ManagePlaceState>(
        builder: (context, state) {
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
                DataColumn(label: ColumnField(name: "Address")),
                DataColumn(label: ColumnField(name: "Quantity")),
                DataColumn(label: ColumnField(name: "Delete")),
              ],
              rows: [
                for (var i = 0; i < state.places.length; i++)
                  placeRow(context, state.places[i], i + 1, state),
              ]);
        },
      ),
    );
  }

  DataRow placeRow(
    BuildContext context,
    Place place,
    int order,
    ManagePlaceState state,
  ) {
    return DataRow(
        onSelectChanged: (value) {
          if (value == true) {
            _updatePlace(context, place, state);
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
              place.address,
              style: AppTextStyles.body,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          // DataCell(
          //   Container(
          //     constraints: const BoxConstraints(maxWidth: 160),
          //     child: Text(
          //       place.address,
          //       style: AppTextStyles.body,
          //       overflow: TextOverflow.ellipsis,
          //       maxLines: 2,
          //     ),
          //   ),
          // ),
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
  void _updatePlace(
    BuildContext context,
    Place place,
    ManagePlaceState state,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return DialogUpdatePlace(
          place: place,
          list: state.places,
        );
      },
    ).then((data) {
      if (data != null && data is Place) {
        final updated = data;
        context.read<ManagePlaceBloc>().add(UpdatePlaceEvent(updated));
      }
    });
  }

  /// Show dialog confirm delete service
  void _deleteService(
    BuildContext context,
    Place place,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Delete this place",
          content:
              "Are your sure you want to delete this place?\nDeleted places cannot be used for other related features.",
        );
      },
    ).then((value) {
      if (value) {
        context.read<ManagePlaceBloc>().add(
              DeletePlaceEvent(
                place,
              ),
            );
      }
    });
  }

  /// Show dialog confirm restore service
  void _restoreService(
    BuildContext context,
    Place place,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return const YesNoDialog(
          title: "Restore deleted place",
          content: "Are you sure you want to restore this place?",
        );
      },
    ).then((value) {
      if (value) {
        context.read<ManagePlaceBloc>().add(
              RestorePlaceEvent(
                place,
              ),
            );
      }
    });
  }
}
