import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/GlobalWidget/Photo_View_Class.dart';
import 'package:rooya/Models/UserChatModel.dart';
import 'package:rooya/Utils/UserDataService.dart';
import 'package:rooya/Utils/primary_color.dart';

import '../UserChat.dart';

class ImageViewUserChat extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const ImageViewUserChat({Key? key, this.model, this.fromGroup})
      : super(key: key);

  @override
  _ImageViewUserChatState createState() => _ImageViewUserChatState();
}

class _ImageViewUserChatState extends State<ImageViewUserChat> {
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
                            '${widget.model!.userData!.firstName}'.isEmpty
                                ? '${widget.model!.userData!.username}'
                                : '${widget.model!.userData!.firstName}' +
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
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: "${widget.model!.media}".contains('http')
                          ? "${widget.model!.media}"
                          : "https://xd.rooya.com/${widget.model!.media}",
                      placeholder: (context, url) => Container(
                        height: height * 0.3,
                        width: width * 0.5,
                        child: Center(
                          child: SpinKitFadingCircle(
                            color: buttonColor,
                            size: 50.0,
                          ),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: buttonColor, width: 1)),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    borderRadius: BorderRadius.circular(8),
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
            padding: EdgeInsets.all(3),
          ),
        ),
        onTap: () {
          context.pushTransparentRoute(Photo_View_Class(
            url: "${widget.model!.media}",
          ));
        },
      );
    } else {
      return InkWell(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width / 1.3),
          child: Container(
            //height: height * 0.32,
            decoration: BoxDecoration(
              color: widget.model!.seen != '0'
                  ? returnColorFromString(seenBackColor)
                  : widget.model!.delivered != '0'
                      ? returnColorFromString(receiveBackColor)
                      : returnColorFromString(sentBackColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: height * 0.32,
                  padding: EdgeInsets.all(5),
                  child: ClipRRect(
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: "${widget.model!.media}",
                          placeholder: (context, url) => Container(
                            height: height * 0.3,
                            width: width * 0.5,
                            child: Center(child: CircularProgressIndicator()),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: buttonColor, width: 1)),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
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
          context.pushTransparentRoute(Photo_View_Class(
            url: "${widget.model!.media}",
          ));
        },
      );
    }
  }
}
