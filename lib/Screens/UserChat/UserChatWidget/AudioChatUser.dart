import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/Utils/primary_color.dart';

import '../../../GlobalWidget/CustomAudioPlayer/CustomAudioPlayer.dart';
import '../../../Models/UserChatModel.dart';
import '../../../Utils/UserDataService.dart';
import '../../../Utils/text_filed/app_font.dart';
import '../UserChat.dart';

class AudioChatUser extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const AudioChatUser({Key? key, this.model, this.fromGroup}) : super(key: key);

  @override
  _AudioChatUserState createState() => _AudioChatUserState();
}

class _AudioChatUserState extends State<AudioChatUser> {
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse("${widget.model!.time}") * 1000);
    if (widget.model!.position != 'right') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: height * 0.1,
          width: width / 1.7,
          padding: EdgeInsets.only(right: 3),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50]!.withOpacity(0.5)
          ),
          child: Column(
            children: [
              widget.fromGroup!
                  ? Column(
                      children: [
                        Text(
                          widget.model!.userData!.firstName!.isEmpty
                              ? '${widget.model!.userData!.username}'
                              : '${widget.model!.userData!.firstName}' +
                                  ' ${widget.model!.userData!.lastName}',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFonts.segoeui,
                              fontSize: 12),
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                      ],
                    )
                  : SizedBox(),
              Container(
                height: height * 0.080,
                width: width / 1.7,
                child: CustomAudioPlayer(
                  url: '${widget.model!.media}',
                color: Colors.blueGrey[50]!.withOpacity(0.2),
                ),
              ),
              Align(
                child: Text(
                  '${dateFormat.format(date)}',
                  style: TextStyle(
                    color: Colors.black26,
                    fontSize: 9.0,
                  ),
                ),
                alignment: Alignment.centerRight,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container(
        height: height * 0.1,
        width: width / 1.7,
        decoration: BoxDecoration(
            color: widget.model!.seen != '0'
                ? returnColorFromString(seenBackColor)
                : widget.model!.delivered != '0'
                ? returnColorFromString(receiveBackColor)
                : returnColorFromString(sentBackColor),
            borderRadius: BorderRadius.circular(8)),
        child: Stack(
          children: [
            Container(
              height: height * 0.080,
              width: width / 1.7,
              child: CustomAudioPlayer(
                color: widget.model!.seen != '0'
                    ? returnColorFromString(seenBackColor)
                    : widget.model!.delivered != '0'
                    ? returnColorFromString(receiveBackColor)
                    : returnColorFromString(sentBackColor),
                url: '${widget.model!.media}',
              ),
            ),
            Align(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${dateFormat.format(date)}',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 9.0,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    widget.model!.seen != '0'
                        ? FaIcon(
                            FontAwesomeIcons.checkDouble,
                            size: 15,
                            color: returnColorFromString(seenCheck),
                          )
                        : widget.model!.delivered != '0'
                            ? FaIcon(
                                FontAwesomeIcons.checkDouble,
                                size: 15,
                                color: returnColorFromString(receiveCheck),
                              )
                            : FaIcon(
                                FontAwesomeIcons.check,
                                size: 15,
                                color: returnColorFromString(sentCheck),
                              ),
                  ],
                ),
              ),
              alignment: Alignment.bottomRight,
            ),
            SizedBox(
              width: 3,
            ),
          ],
        ),
      );
    }
  }
}
