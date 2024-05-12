import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/routers.dart';
import 'package:famitree/src/core/utils/check_connectivity.dart';
import 'package:famitree/src/core/utils/show_message_dialog.dart';
import 'package:famitree/src/services/notifiers/current_user.dart';
import 'package:famitree/src/views/common/circle_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      backgroundColor: AppColor.background,
      body: Consumer<CurrentUser>(
        builder: (context, currentUser, child) {
          return ListView(children: [
            Container(
                height: MediaQuery.of(context).size.height - 160,
                margin: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Update profile",
                        style: TextStyle(
                            fontSize: 36.00, fontWeight: FontWeight.w900),
                      ),
                    ),
                    Center(
                      child: Stack(
                        children: [
                          CircleImage(
                              size: 120, imgUrl: currentUser.user.profileImage),
                          Container(
                            width: 120,
                            height: 120,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(50, 0, 0, 0),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () async {
                                  if (!(await checkInternetConnectivity())) {
                                      displayNoInternet();
                                      return;
                                    }
                                  if (!mounted) return;
                                  Navigator.of(context)
                                      .popAndPushNamed(AppRouter.updateProfilePic);
                                },
                                icon: const Icon(Icons.camera_alt_outlined)),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: AppColor.text),
                      cursorColor: AppColor.text,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: 'Your name',
                          hintStyle: TextStyle(color: AppColor.text.withAlpha(180))),
                    ),
                    const SizedBox(height: 4,),
                    ElevatedButton(
                        // style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(25), // <-- Radius
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.00,
                          ),
                        ),
                        onPressed: () async {
                          if (!(await checkInternetConnectivity())) {
                            displayNoInternet();
                            return;
                          }
                          if (!mounted) return;
                          final _nameText =
                              _nameController.text.trim();
                          await currentUser.user.updateInfo(
                              name: _nameText,);
                          Provider.of<CurrentUser>(context, listen: false)
                              .setName();
                          await showMessageDialog(
                              context, "Update profile successfully.");
                          Navigator.of(context).pop();
                        }),
                    TextButton(
                      child: const Text("Cancel",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.00,
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )),
          ]);
        },
      ),
    );
  }
}
