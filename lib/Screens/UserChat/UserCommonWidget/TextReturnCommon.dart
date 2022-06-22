import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/UserChatModel.dart';
import '../../../Utils/text_filed/app_font.dart';
import '../../Information/UserChatInformation/user_chat_information.dart';
import '../UserChat.dart';

class TextReplyCommon extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const TextReplyCommon({Key? key, this.model, this.fromGroup})
      : super(key: key);

  @override
  State<TextReplyCommon> createState() => _TextReplyCommonState();
}

class _TextReplyCommonState extends State<TextReplyCommon> {
  @override
  Widget build(BuildContext context) {
    if (!widget.fromGroup!) {
      return Text(
        '${widget.model!.text}',
        style: TextStyle(
            color: widget.model!.seen != '0'
                ? returnColorFromString(seenTextColor)
                : widget.model!.delivered != '0'
                    ? returnColorFromString(receiveTextColor)
                    : returnColorFromString(sentTextColor),
            fontWeight: FontWeight.w300,
            fontFamily: AppFonts.segoeui,
            fontSize: 14),
      );
    }
    if (groupModelGlobel!.parts!.isEmpty) {
      return Text(
        '${widget.model!.text}',
        style: TextStyle(
            color: widget.model!.seen != '0'
                ? returnColorFromString(seenTextColor)
                : widget.model!.delivered != '0'
                    ? returnColorFromString(receiveTextColor)
                    : returnColorFromString(sentTextColor),
            fontWeight: FontWeight.w300,
            fontFamily: AppFonts.segoeui,
            fontSize: 14),
      );
    }

    String newValue = widget.model!.text!;
    // List value = widget.model!.text.toString().split(' ');
    // groupModelGlobel!.parts!.forEach((e) {
    //   value.forEach((element) {
    //     if (element.toString().contains('@${e.username}')) {
    //       newValue = newValue +
    //           '$element '.replaceAll('@${e.username}', ' @${e.username} ');
    //     } else {
    //       newValue = newValue + '$element ';
    //     }
    //   });
    // });
    // print('newValue = ${newValue}');

    return Text.rich(
      TextSpan(
          text: '',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: newValue.split(' ').map((w) {
            return w.startsWith('@') && w.length > 1
                ? TextSpan(
                    text: ' ' + w,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue,
                        fontWeight: FontWeight.normal),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        String value = w.replaceAll('@', '').trim().toString();
                        int index = groupModelGlobel!.parts!
                            .indexWhere((element) => element.username == value);
                        Get.to(UserChatInformation(
                            userID: groupModelGlobel!.parts![index].userId
                                .toString()));
                      },
                  )
                : TextSpan(
                    text: ' ' + w,
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  );
          }).toList()),
      maxLines: 1000,
      overflow: TextOverflow.ellipsis,
    );
  }
}
