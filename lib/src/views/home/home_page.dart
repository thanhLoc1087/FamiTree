import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/services/auth/auth_service.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:famitree/src/views/home/views/popup_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/create_tree_form.dart';
import 'views/my_tree.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController treeCode;
  String? error;
  @override
  void initState() {
    treeCode = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    BlocProvider.of<HomePageBloc>(context).add(const InitHomeEvent());
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    treeCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.background,
        floatingActionButton: const MyFloatingActionButton(),
        body: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
            if (CurrentUser().user.treeCode?.isNotEmpty == false || state.myTree == null) {
              return Center(
                child: AuthService.firebase().currentUser?.isEmailVerified ?? true ?
                 Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("You currently do not have a tree yet."),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () async {
                        final data = await showDialog(
                          context: context,
                          builder: (context) {
                            return const CreateTreeForm();
                          },
                        );
                        if (data != null) {
                          debugPrint(data);
                        }
                      },
                      child: const Text("Create your own tree"),
                    ),
                    const SizedBox(height: 20,),
                    const Divider(),
                    const SizedBox(height: 20,),
                    const Text("Or join your family's tree."),
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
                          onPressed: () {
                            if (treeCode.text.trim().isEmpty) {
                              setState(() {
                                error = "It's empty";
                              });
                            } else {
                              BlocProvider.of<HomePageBloc>(context).add(JoinTreeHomeEvent(treeCode.text.trim()));
                            }
                          }, 
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('Join'),
                          )
                        )
                      ],
                    )
                  ],
                ) : const Column(
                  children: [
                    Text("You must verify your email to create a tree"),
                  ],
                ),
              );
            }
            return Center(
              child: FamilyTreeWidget(
              familyTree: state.myTree!,
            ));
          },
        ),
      ),
    );
  }
}
