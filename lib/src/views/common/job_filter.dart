import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/common_utils.dart';
import 'package:famitree/src/data/models/job.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'autocompleter.dart';

class JobFilter extends StatefulWidget {
  final String initText;
  final String? errorText;
  final List<Job> allValues;
  final Function(Job)? onSelected;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final double? width;

  const JobFilter({
    super.key,
    this.initText = "",
    this.errorText,
    required this.allValues,
    this.onSelected,
    this.onChanged,
    this.onFieldSubmitted,
    this.width,
  });

  @override
  State<JobFilter> createState() => _JobFilterState();
}

class _JobFilterState extends State<JobFilter> {
  final FocusNode focusNode = FocusNode();
  final controller = TextEditingController();

  bool showDelete = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.text = widget.initText;

    showDelete = controller.text.isNotEmpty;
    super.initState();

    controller.addListener(() {
      if (controller.text.isEmpty) {
        if (showDelete) {
          setState(() {
            showDelete = false;
          });
        }
      } else {
        if (!showDelete) {
          setState(() {
            showDelete = true;
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant JobFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initText != oldWidget.initText ||
        oldWidget.allValues != widget.allValues) {
      // Logger().w(widget.initText);
      controller.text = widget.initText;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return RawAutocomplete(
        textEditingController: controller,
        focusNode: focusNode,
        optionsViewBuilder: (newContext, onSelected, options) {
          return _buildOption(options);
        },
        optionsBuilder: (textEditingValue) {
          String query = textEditingValue.text.toLowerCase();
          return widget.allValues.where((e) =>
              removeVietnameseTones(e.name.toLowerCase())
                  .contains(removeVietnameseTones(query.toLowerCase())));
        },
        displayStringForOption: (option) {
          return option.name;
        },
        fieldViewBuilder: (
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
        ) {
          return _buildTextField(textEditingController, focusNode);
        },
      );
    }

    /// For mobile
    return MyRawAutocomplete(
      textEditingController: controller,
      focusNode: focusNode,
      optionsViewBuilder: (newContext, onSelected, options) {
        return _buildOption(options);
      },
      optionsBuilder: (textEditingValue) {
        String query = textEditingValue.text.toLowerCase();
        return widget.allValues.where((e) =>
            removeVietnameseTones(e.name.toLowerCase())
                .contains(removeVietnameseTones(query.toLowerCase())));
      },
      displayStringForOption: (option) {
        return option.name;
      },
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return _buildTextField(textEditingController, focusNode);
      },
    );
  }

  Widget _buildTextField(
    TextEditingController textEditingController,
    FocusNode focusNode,
  ) {
    return TextField(
      controller: textEditingController,
      textCapitalization: TextCapitalization.words,
      focusNode: focusNode,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      onSubmitted: (value) {
        if (widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(value);
        }
      },
      textInputAction: TextInputAction.done,
      style: const TextStyle(
        color: AppColor.text,
        fontSize: 15,
        decorationThickness: 0,
      ),
      cursorColor: AppColor.text,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        errorText:
            widget.errorText?.isNotEmpty == true ? widget.errorText : null,
        errorMaxLines: 2,
        errorStyle: const TextStyle(fontSize: 14),
        hintText: 'Choose job',
        hintStyle: const TextStyle(color: Colors.black45),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        border: tfBorder().copyWith(borderSide: BorderSide.none),
        enabledBorder: tfBorder(),
        focusedBorder: tfBorder().copyWith(
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: tfBorder().copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        suffixIconConstraints: const BoxConstraints(maxWidth: 40),
        suffixIcon: InkWell(
          onTap: () {
            controller.text = "";
            if (widget.onChanged != null) {
              widget.onChanged!("");
            }
          },
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              showDelete ? Icons.cancel : Icons.arrow_drop_down,
              color: AppColor.interactive,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOption(Iterable<Job> options) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Align(
        alignment: kIsWeb ? Alignment.topLeft : Alignment.bottomLeft,
        child: Material(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 250,
              maxWidth: widget.width ?? 350,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Scrollbar(
              child: ListView.builder(
                reverse: !kIsWeb,
                physics: const ClampingScrollPhysics(),
                itemCount: options.length,
                shrinkWrap: options.length < 5,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (newContext, index) {
                  final option = options.elementAt(index);
                  return InkResponse(
                    onTap: () {
                      focusNode.unfocus();
                      controller.text = option.name;

                      // Comment để giảm lag :)))
                      // onSelected(option);

                      if (widget.onSelected != null) {
                        widget.onSelected!(option);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Text(
                        "${option.name} (${option.description})",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder tfBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.text.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
