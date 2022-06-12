import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/Utils/primary_color.dart';
import 'package:path/path.dart' as p;
import '../../../GlobalWidget/FileUploader.dart';
import '../../../Models/UserChatModel.dart';
import '../../../Utils/UserDataService.dart';
import '../../../Utils/text_filed/app_font.dart';
import '../UserChat.dart';

class DocumentUserChat extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const DocumentUserChat({Key? key, this.model, this.fromGroup})
      : super(key: key);

  @override
  _DocumentUserChatState createState() => _DocumentUserChatState();
}

class _DocumentUserChatState extends State<DocumentUserChat> {
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(
        int.parse("${widget.model!.time}") * 1000);
    if (widget.model!.position != 'right') {
      return InkWell(
        child: Container(
          padding: EdgeInsets.all(5),
          width: width / 3,
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
              Icon(
                Icons.file_copy_outlined,
                size: 40,
                color: primaryColor,
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  p
                      .basename(
                        '${widget.model!.media}',
                      )
                      .toString(),
                  style: TextStyle(fontSize: 10),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 5,
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black12,
              ),
              borderRadius: BorderRadius.circular(10)),
        ),
        onTap: () async {
          String filePath = await saveAudioFile(
              url: '${widget.model!.media}',
              extension: 'file',
              fileNName: p.basename('${widget.model!.media}'));
          await OpenFile.open(filePath);
        },
      );
    } else {
      return InkWell(
        child: Container(
          padding: EdgeInsets.all(5),
          width: width / 3,
          child: Column(
            children: [
              Icon(
                Icons.file_copy_outlined,
                size: 40,
                color: Colors.blue,
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  p.basename('${widget.model!.media}').toString(),
                  style: TextStyle(fontSize: 10),
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                child: Row(
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
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                alignment: Alignment.centerRight,
              ),
              SizedBox(
                width: 3,
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black12,
              ),
              color: widget.model!.seen != '0'
                  ? returnColorFromString(seenBackColor)
                  : widget.model!.delivered != '0'
                      ? returnColorFromString(receiveBackColor)
                      : returnColorFromString(sentBackColor),
              borderRadius: BorderRadius.circular(10)),
        ),
        onTap: () async {
          String filePath = await saveAudioFile(
              url: '${widget.model!.media}',
              extension: 'file',
              fileNName: p.basename('${widget.model!.media}'));
          await OpenFile.open(filePath);
        },
      );
    }
  }
}
