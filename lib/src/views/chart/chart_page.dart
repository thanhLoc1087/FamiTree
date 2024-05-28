import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/utils/common_utils.dart';
import 'package:famitree/src/data/models/achievement.dart';
import 'package:famitree/src/data/models/death.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:famitree/src/views/chart/chart_achievement.dart';
import 'package:famitree/src/views/chart/chart_death.dart';
import 'package:famitree/src/views/chart/chart_member.dart';
import 'package:famitree/src/views/home/bloc/home_page_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late final TextEditingController input;
  String? error;

  late final ValueNotifier<List<Member>> filteredMember;

  @override
  void initState() {
    input = TextEditingController();
    filteredMember = ValueNotifier([]);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Chart", 
          style: TextStyle(color: AppColor.text),
        ),
        leading: const BackButton(color: AppColor.text,),
      ),
      body: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.sizeOf(context).width,
        ),
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 20 : 0),
        child: BlocBuilder<HomePageBloc, HomePageState>(
          builder: (context, state) {
              if (state.myTree?.firstMember == null) {
                return const Center(
                  child: Text('No data'),
                );
              }

              List<Member> newMembers = [];
              
              void dfs(Member member) {
                newMembers.add(member);

                // Recursively process each child
                for (var child in member.children ?? []) {
                  dfs(child);
                }
              }

              dfs(state.myTree!.firstMember!);

              filteredMember.value = newMembers;

              return SingleChildScrollView(
                child: ValueListenableBuilder(
                  valueListenable: filteredMember,
                  builder: (context, value, child) {
                    
              Map<Achievement, String> mapMemberAchievement = {};
              for (var element in value) {
                mapMemberAchievement.addAll({
                  for (var avm in element.achievements)
                    avm: element.name
                });
              }

              Map<Death, String> mapMemberDeath = {};
              for (var element in value) {
                mapMemberDeath.addAll({
                  if (element.death != null)
                    element.death!: element.name
                });
              }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: input,
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
                                    filteredMember.value = [...newMembers]..retainWhere((element) => 
                                      removeVietnameseTones(element.name.trim()).contains(removeVietnameseTones(input.text))
                                    );
                                  }
                                  },
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: "Search member name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      input.text = "";
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
                              if (input.text.trim().isEmpty) {
                                setState(() {
                                  error = "It's empty";
                                });
                              } else {
                                filteredMember.value = [...newMembers]..retainWhere((element) => 
                                  removeVietnameseTones(element.name.trim()).contains(removeVietnameseTones(input.text))
                                );
                              }
                            }, 
                            child: const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('View'),
                            )
                          )
                        ],
                                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Members (${value.length})",
                          style: const TextStyle(
                            color: AppColor.text,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (value.isNotEmpty)
                      ChartMembers(
                        members: value,
                        firstMember: state.myTree!.firstMember!,
                      ) else const Center(
                        child: Text('No data'),
                      ),
                  
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Achievements (${mapMemberAchievement.keys.length})",
                          style: const TextStyle(
                            color: AppColor.text,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (mapMemberAchievement.isNotEmpty)
                      ChartAchievement(
                        achievements: mapMemberAchievement,
                        canAdd: false
                      ) else const Center(
                        child: Text('No data'),
                      ),
                  
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Death (${mapMemberDeath.keys.length})",
                          style: const TextStyle(
                            color: AppColor.text,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (mapMemberDeath.isNotEmpty)
                      ChartDeath(
                        mapMemberDeath: mapMemberDeath,
                      ) else const Center(
                        child: Text('No data'),
                      ),
                      const SizedBox(height: 40,)
                    ],
                  );
                }
              ),
            );
          }
        )
      ),
    );
  }
}