import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/Models/UserChatModel.dart';
import '../../Information/UserChatInformation/user_chat_information.dart';

class ProfileImageUserCommon extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const ProfileImageUserCommon({Key? key, this.model, this.fromGroup}) : super(key: key);

  @override
  _ProfileImageUserCommonState createState() => _ProfileImageUserCommonState();
}

class _ProfileImageUserCommonState extends State<ProfileImageUserCommon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: CircularProfileAvatar(
        '',
        onTap: () {
          if (widget.model!.userData == null) {
            Get.to(UserChatInformation(userID: widget.model!.messageUser!.userId));
          } else {
            Get.to(UserChatInformation(
              userID: widget.model!.userData!.userId.toString(),
            ));
          }
        },
        radius: 15,
        backgroundColor: Colors.blueGrey[100]!,
        child: CachedNetworkImage(
          imageUrl: widget.fromGroup!
              ? widget.model!.userData == null
              ? ''
              : '${widget.model!.userData!.avatar}'
              : '${widget.model!.messageUser!.avatar}',
          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => CachedNetworkImage(
            imageUrl: widget.fromGroup!
                ? widget.model!.userData == null
                ? ''
                : 'https://xd.rooya.com/${widget.model!.userData!.avatar}'
                : 'https://xd.rooya.com/${widget.model!.messageUser!.avatar}',
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.person),
            fit: BoxFit.cover,
          ),
          fit: BoxFit.cover,
        ),
        imageFit: BoxFit.cover,
      ),
    );
  }
}
