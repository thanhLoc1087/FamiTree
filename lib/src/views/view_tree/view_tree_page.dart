import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/text_style.dart';
import 'package:famitree/src/data/models/family_tree.dart';
import 'package:famitree/src/services/tree_services/tree_firebase_service.dart';
import 'package:famitree/src/views/home/views/my_tree.dart';
import 'package:famitree/src/views/home/views/popup_menu_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewTreePage extends StatefulWidget {
  const ViewTreePage({
    super.key,
  });

  @override
  State<ViewTreePage> createState() => _ViewTreePageState();
}

class _ViewTreePageState extends State<ViewTreePage> {
  late final TextEditingController treeCode;
  String? error;

  late final ValueNotifier<FamilyTree?> tree;

  @override
  void initState() {
    treeCode = TextEditingController();
    tree = ValueNotifier(null);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    treeCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("View trees", style: AppTextStyles.header,),
        leading: const BackButton(color: AppColor.primary,),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.background,
      floatingActionButton: const MyFloatingActionButton(),
      body: Center(
            child: Column(
              children: [
                
                  const Text("See other's trees."),
                  const SizedBox(height: 20,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: treeCode,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                            color: AppColor.text,
                          ),
                          maxLength: 50,
                          onChanged: (value) {
                            if (value.trim().isNotEmpty &&
                                error != null) {
                              setState(() {
                                error = null;
                              });
                            }
                            },
                          decoration: InputDecoration(
                            counterText: "",
                            hintText: "Enter tree code",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                treeCode.text = "";
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
                            errorText: error,
                          ),
                        ),
                      ),
                const SizedBox(width: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        if (treeCode.text.trim().isEmpty) {
                          setState(() {
                            error = "It's empty";
                          });
                        } else {
                            tree.value = await TreeRemoteService().getTreeByViewCode(treeCode.text.trim());
                            if (tree.value == null) {
                              setState(() {
                                error = "Cannot find tree";
                              });
                            }
                        }
                      }, 
                      child: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text('View'),
                      )
                    )
                  ],
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: tree,
                    builder: (BuildContext context, value, Widget? child) {  
                      if (value != null) {
                        return FamilyTreeWidget(
                          familyTree: value,
                          readOnly: true,
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ))
    );
  }
}
