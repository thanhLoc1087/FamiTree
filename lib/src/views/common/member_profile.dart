import 'package:cached_network_image/cached_network_image.dart';
import 'package:famitree/src/core/constants/colors.dart';
import 'package:famitree/src/core/constants/images_path.dart';
import 'package:famitree/src/data/models/member.dart';
import 'package:flutter/material.dart';

class MemberProbile extends StatelessWidget {
  const MemberProbile({super.key, required this.member});

  final Member member;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              member.image?.isNotEmpty == true ? 
              CircleAvatar(
                  radius: 60,
                  backgroundImage: CachedNetworkImageProvider(member.image!),
                ) : const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(AppImage.defaultProfile),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(
                      color: AppColor.text,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(
                    '${member.homeland.name} - ${member.homeland.address}',
                    style: const TextStyle(
                      color: AppColor.text,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              )
            ],
          ),
        ],),
    );
  }
}