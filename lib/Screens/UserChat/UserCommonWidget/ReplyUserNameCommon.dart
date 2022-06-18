import 'package:flutter/material.dart';

import '../../../ApiConfig/SizeConfiq.dart';
import '../../../Models/UserChatModel.dart';
import '../../../Utils/text_filed/app_font.dart';

class ReplyUserName extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const ReplyUserName({Key? key, this.model, this.fromGroup}) : super(key: key);

  @override
  _ReplyUserNameState createState() => _ReplyUserNameState();
}

class _ReplyUserNameState extends State<ReplyUserName> {
  @override
  Widget build(BuildContext context) {
    return widget.fromGroup!
        ? Column(
            children: [
              Text(
                widget.model!.userData!.firstName!.isEmpty
                    ? '${widget.model!.userData!.username}'
                    : '${widget.model!.userData!.firstName}' + ' ${widget.model!.userData!.lastName}',
                style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontFamily: AppFonts.segoeui, fontSize: 12),
              ),
              SizedBox(
                height: height / 100,
              ),
            ],
          )
        : SizedBox();
  }
}
