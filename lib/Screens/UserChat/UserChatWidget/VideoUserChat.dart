import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';

import '../../../GlobalWidget/CustomVideoPlayer.dart';
import '../../../Models/UserChatModel.dart';
import '../../../Utils/UserDataService.dart';
import '../UserChat.dart';

class VideoUserChat extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const VideoUserChat({Key? key, this.model, this.fromGroup}) : super(key: key);

  @override
  _VideoUserChatState createState() => _VideoUserChatState();
}

class _VideoUserChatState extends State<VideoUserChat> {
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse("${widget.model!.time}") * 1000);
    if (widget.model!.position != 'right') {
      return InkWell(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width / 1.3),
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xffF3F3F3),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.fromGroup!
                    ? Column(
                        children: [
                          Text(
                            '${widget.model!.userData!.firstName}'.isEmpty? '${widget.model!.userData!.username}':  '${widget.model!.userData!.firstName}' +
                                ' ${widget.model!.userData!.lastName}',
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          SizedBox(
                            height: height / 100,
                          ),
                        ],
                      )
                    : SizedBox(),
                Container(
                  width: width / 1.3,
                  height: height * 0.3,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Visibility(
                  visible: '${widget.model!.text}'.isNotEmpty ? true : false,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width / 1.3),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Text(
                        '${widget.model!.text}',
                        //  decrypString(
                        //      encript: '${widget.model!.text}',
                        //      pass: widget.model!.time),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${dateFormat.format(date)}',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 9.0,
                      ),
                    ),
                  ),
                  alignment: Alignment.bottomRight,
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Get.to(CustomVideoPlayer(
            url: widget.model!.media!.contains('http')
                ? widget.model!.media!
                : 'https://xd.rooya.com/${widget.model!.media!}',
          ));
        },
      );
    } else {
      return InkWell(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width / 1.3),
          child: Container(
            decoration: BoxDecoration(
                color: widget.model!.seen != '0'
                    ? returnColorFromString(seenBackColor)
                    : widget.model!.delivered != '0'
                        ? returnColorFromString(receiveBackColor)
                        : returnColorFromString(sentBackColor),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: width / 1.3,
                  height: height / 3,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Visibility(
                  visible: '${widget.model!.text}'.isNotEmpty ? true : false,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width / 1.3),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5),
                      child: Text(
                        '${widget.model!.text}',
                        //  decrypString(
                        //      encript: '${widget.model!.text}',
                        //      pass: widget.model!.time),
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${dateFormat.format(date)}',
                          style: TextStyle(
                            color: Colors.white,
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
              ],
            ),
          ),
        ),
        onTap: () {
          Get.to(CustomVideoPlayer(
            url: widget.model!.media!.contains('http')
                ? widget.model!.media!
                : 'https://xd.rooya.com/${widget.model!.media!}',
          ));
          // Get.to(
          //     VideoApp(
          //   assetsPath:
          //       '${getcontroller!.oneToOneChat[i].message!.message}',
          // ));
        },
      );
    }
  }
}
