import 'package:flutter/material.dart';

import '../../../ApiConfig/SizeConfiq.dart';
import '../../../Models/UserChatModel.dart';
import '../../../Utils/UserDataService.dart';
import '../../../Utils/text_filed/app_font.dart';

class TimeRetuernCommon extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const TimeRetuernCommon({Key? key, this.model, this.fromGroup}) : super(key: key);

  @override
  _TimeRetuernCommonState createState() => _TimeRetuernCommonState();
}

class _TimeRetuernCommonState extends State<TimeRetuernCommon> {
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse("${widget.model!.time}") * 1000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: width / 50),
          child: Text(
            '${dateFormat.format(date)}',
            style: TextStyle(
              color: Colors.black26,
              fontFamily: AppFonts.segoeui,
              fontSize: 9.0,
            ),
          ),
        ),
      ],
    );
  }
}
