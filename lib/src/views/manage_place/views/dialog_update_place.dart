import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/screen_util.dart';
import 'package:famitree/src/data/models/place.dart';
import 'package:famitree/src/views/common/keyboard_dismiss.dart';
import 'package:flutter/material.dart';

class DialogUpdatePlace extends StatefulWidget {
  const DialogUpdatePlace({
    super.key,
    this.place,
    required this.list,
  });

  final List<Place> list;
  final Place? place;

  @override
  State<DialogUpdatePlace> createState() => _DialogUpdatePlaceState();
}

class _DialogUpdatePlaceState extends State<DialogUpdatePlace> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  final _nameFocus = FocusNode();
  final _addressFocus = FocusNode();

  String? errorName;
  String? errorAddress;

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.place?.name ?? "";
    _addressController.text = widget.place?.address ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();

    _nameFocus.dispose();
    _addressFocus.dispose();

    super.dispose();
  }

  _submit() {
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorName = "The name of this place cannot be empty";
      });
      return;
    }
    if (address.isEmpty) {
      setState(() {
        errorAddress = "The address of this place cannot be empty!";
      });
      return;
    }

    Place updated;
    if (widget.place != null) {
      updated = widget.place!.copyWith(
        name: name,
        address: address,
      );
    } else {
      updated = Place(
        id: "",
        name: name, 
        address: address, 
        quantity: 0,
      );
    }

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismiss(
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 12),
        // padding: const EdgeInsets.only(top: 10),
        child: Material(
          color: Colors.transparent,
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Container(
                width: ScreenUtils.isTablet()
                    ? MediaQuery.sizeOf(context).width * 0.7
                    : MediaQuery.sizeOf(context).width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(maxWidth: 600),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Place name",
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocus,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Enter place name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _nameController.text = "";
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColor.interactive,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.clear,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              errorText: errorName,
                            ),
                            onChanged: (value) {
                              if (value.trim().isNotEmpty &&
                                  errorName != null) {
                                setState(() {
                                  errorName = null;
                                });
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              _addressFocus.nextFocus();
                            },
                            style: const TextStyle(
                              color: AppColor.text,
                            ),
                            maxLength: 50,
                          ),
                          const SizedBox(height: 15),
                          
                          const Text(
                            "Address",
                            style: TextStyle(
                              color: AppColor.text,
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _addressController,
                            focusNode: _addressFocus,
                            autofocus: true,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "Enter address",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _addressController.text = "";
                                },
                                icon: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColor.interactive,
                                  ),
                                  padding: const EdgeInsets.all(2),
                                  child: const Icon(
                                    Icons.clear,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              errorText: errorAddress,
                            ),
                            onChanged: (value) {
                              if (value.trim().isNotEmpty &&
                                  errorAddress != null) {
                                setState(() {
                                  errorAddress = null;
                                });
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              _submit();
                            },
                            style: const TextStyle(
                              color: AppColor.text,
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.interactive,
                              fixedSize:
                                  Size(MediaQuery.sizeOf(context).width, 50),
                            ),
                            child: const Text(
                              "SAVE",
                              style: TextStyle(color: AppColor.text),
                            ),
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.clear,
                          size: 30,
                        ),
                        color: AppColor.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
