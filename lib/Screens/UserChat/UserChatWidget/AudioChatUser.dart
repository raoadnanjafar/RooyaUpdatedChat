import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/Utils/primary_color.dart';

import '../../../GlobalWidget/CustomAudioPlayer/CustomAudioPlayer.dart';
import '../../../Models/UserChatModel.dart';
import '../../../Utils/UserDataService.dart';
import '../../../Utils/text_filed/app_font.dart';
import '../../Information/UserChatInformation/user_chat_information.dart';
import '../../chat_screen.dart';
import 'package:get/get.dart';
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
      if(widget.model!.replyId == '0'){
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
      }else{
        if(widget.model!.reply!.type == 'text'){
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
              ),
              Container(
                // padding: EdgeInsets.only(right: width / 30, bottom: width / 30),
                decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    widget.fromGroup!
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
                        : SizedBox(),
                    Container(
                      height: height * 0.070,
                      width: width*0.57,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                      child: Row(children: [
                        Container(
                          height: height * 0.070,
                          width: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('${widget.model!.messageUser!.fName} ' +
                                '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: width / 1.5),
                              child: Text(
                                '${widget.model!.reply!.text}   ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                    ClipRRect(
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
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ],
          );
        }else{
          if(widget.model!.reply!.type == 'image'){
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
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
                ),
                Container(
                  // padding: EdgeInsets.only(right: width / 30, bottom: width / 30),
                  decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      widget.fromGroup!
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
                          : SizedBox(),
                      Container(
                        height: height * 0.070,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                        child: Row(children: [
                          Container(
                            height: height * 0.070,
                            width: 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5),
                              Text('${widget.model!.messageUser!.fName} ' +
                                  '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: width / 1.5),
                                child: Text(
                                  '${widget.model!.reply!.type}   ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                         // Expanded(child: SizedBox()),
                          SizedBox(width: 100,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              width: 50,
                              height: 50,
                              child: CachedNetworkImage(
                                imageUrl: '${widget.model!.reply!.media}',
                                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error_outline_outlined),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ]),
                      ),
                      ClipRRect(
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
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ],
            );
          }else{
            if(widget.model!.reply!.type == 'video'){
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
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
                  ),
                  Container(
                    // padding: EdgeInsets.only(right: width / 30, bottom: width / 30),
                    decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        // widget.fromGroup!
                        //     ? Column(
                        //   children: [
                        //     Text(
                        //       widget.model!.userData!.firstName!.isEmpty
                        //           ? '${widget.model!.userData!.username}'
                        //           : '${widget.model!.userData!.firstName}' + ' ${widget.model!.userData!.lastName}',
                        //       style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontFamily: AppFonts.segoeui, fontSize: 12),
                        //     ),
                        //     SizedBox(
                        //       height: height / 100,
                        //     ),
                        //   ],
                        // )
                        //     : SizedBox(),
                        Container(
                          height: height * 0.070,
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                          child: Row(children: [
                            Container(
                              height: height * 0.070,
                              width: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text('${widget.model!.messageUser!.fName} ' +
                                    '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: width / 1.5),
                                  child: Text(
                                    '${widget.model!.reply!.type}   ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            // Expanded(child: SizedBox()),
                            SizedBox(width: 100,),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(5)),

                              child: Center(
                                child: Stack(
                                  children: [
                                    Image.network('https://xd.rooya.com/${widget.model!.reply!.thumb}',fit: BoxFit.fill),
                                    Positioned(
                                        top: 12,
                                        child: Icon(Icons.play_circle_filled,color: Colors.white,)),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        ClipRRect(
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
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              );
            }else{
              if(widget.model!.reply!.type == 'file'){
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
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
                    ),
                    Container(
                      // padding: EdgeInsets.only(right: width / 30, bottom: width / 30),
                      decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          widget.fromGroup!
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
                              : SizedBox(),
                          Container(
                            height: height * 0.070,
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                            child: Row(children: [
                              Container(
                                height: height * 0.070,
                                width: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text('${widget.model!.messageUser!.fName} ' +
                                      '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                                  Row(
                                    children: [
                                      Icon(Icons.attach_file),
                                      SizedBox(width: 5,),
                                      Text(
                                        '${widget.model!.reply!.type}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          ClipRRect(
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
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                );
              }else{
                if(widget.model!.reply!.type == 'audio'){
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
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
                      ),
                      Container(
                        // padding: EdgeInsets.only(right: width / 30, bottom: width / 30),
                        decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            widget.fromGroup!
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
                                : SizedBox(),
                            Container(
                              height: height * 0.070,
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                              child: Row(children: [
                                Container(
                                  height: height * 0.070,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text('${widget.model!.messageUser!.fName} ' +
                                        '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                                    Container(
                                      //width: 50,
                                      //color: Colors.black,
                                      child: Row(
                                        children: [
                                          Icon(Icons.mic),
                                          Text('Voice message')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                            ),
                            ClipRRect(
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
                            )
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  );
                }
              }
            }
          }
        }
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
      }
      /// for user reply
    } else {
      if(widget.model!.replyId == '0'){
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
      }else{
        if(widget.model!.reply!.type == 'text'){
          return Container(
            decoration: BoxDecoration(
                color: widget.model!.seen != '0'
                    ? returnColorFromString(seenBackColor)
                    : widget.model!.delivered != '0'
                    ? returnColorFromString(receiveBackColor)
                    : returnColorFromString(sentBackColor),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: height * 0.070,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(
                          height: height * 0.070,
                          width: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('${widget.model!.messageUser!.fName} ' +
                                '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: width / 1.5),
                              child: Text(
                                '${widget.model!.reply!.text}   ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: SizedBox()),
                      ]),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
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
                )
              ],
            ),
          );
        }else{
          if(widget.model!.reply!.type == 'image'){
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: widget.model!.seen != '0'
                          ? returnColorFromString(seenBackColor)
                          : widget.model!.delivered != '0'
                          ? returnColorFromString(receiveBackColor)
                          : returnColorFromString(sentBackColor),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Container(
                        height: height * 0.070,
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                        margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.070,
                                width: 4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                  color: Colors.deepPurple,
                                ),
                              ),
                              SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Text('${widget.model!.messageUser!.fName} ' +
                                      '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: width / 1.5),
                                    child: Text(
                                      '${widget.model!.reply!.type}   ',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: '${widget.model!.reply!.media}',
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.error_outline_outlined),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ]),
                      ),
                      Container(
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
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ],
            );
          }else{
            if(widget.model!.reply!.type == 'video'){
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: widget.model!.seen != '0'
                            ? returnColorFromString(seenBackColor)
                            : widget.model!.delivered != '0'
                            ? returnColorFromString(receiveBackColor)
                            : returnColorFromString(sentBackColor),
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.070,
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: height * 0.070,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                    Text('${widget.model!.messageUser!.fName} ' +
                                        '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(maxWidth: width / 1.5),
                                      child: Text(
                                        '${widget.model!.reply!.type}   ',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(child: SizedBox()),
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(5)),

                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Image.network('https://xd.rooya.com/${widget.model!.reply!.thumb}',fit: BoxFit.fill),
                                        Positioned(
                                            top: 12,
                                            child: Icon(Icons.play_circle_filled,color: Colors.white,)),
                                      ],
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
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
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              );
            }else{
              if(widget.model!.reply!.type == 'file'){
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: widget.model!.seen != '0'
                              ? returnColorFromString(seenBackColor)
                              : widget.model!.delivered != '0'
                              ? returnColorFromString(receiveBackColor)
                              : returnColorFromString(sentBackColor),
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Container(
                            //height: height * 0.070,
                            decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.070,
                                    width: 4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Text('${widget.model!.messageUser!.fName} ' +
                                          '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                                      Row(
                                        children: [
                                          Icon(Icons.attach_file),
                                          SizedBox(width: 5,),
                                          Text(
                                            '${widget.model!.reply!.type}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                          Container(
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
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ],
                );
              }else{
                if(widget.model!.reply!.type == 'audio'){
                  return Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: widget.model!.seen != '0'
                                ? returnColorFromString(seenBackColor)
                                : widget.model!.delivered != '0'
                                ? returnColorFromString(receiveBackColor)
                                : returnColorFromString(sentBackColor),
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Container(
                              height: height * 0.070,
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height * 0.070,
                                      width: 4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text('${widget.model!.messageUser!.fName} ' +
                                            '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                                        Container(
                                          //width: 50,
                                          //color: Colors.black,
                                          child: Row(
                                            children: [
                                              Icon(Icons.mic),
                                              Text('Voice message')
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]),
                            ),
                            Container(
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
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ],
                  );
                }
              }
            }
          }
          return Container(
            decoration: BoxDecoration(
                color: widget.model!.seen != '0'
                    ? returnColorFromString(seenBackColor)
                    : widget.model!.delivered != '0'
                    ? returnColorFromString(receiveBackColor)
                    : returnColorFromString(sentBackColor),
                borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: height * 0.070,
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                      margin: EdgeInsets.only(left: width * 0.010, right: width * 0.010, top: height * 0.0050),
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Container(
                          height: height * 0.070,
                          width: 4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
                            color: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 5),
                            Text('${widget.model!.messageUser!.fName} ' +
                                '${widget.model!.messageUser!.lName}   ',style: TextStyle(color: Colors.blue)),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: width / 1.5),
                              child: Text(
                                '${widget.model!.reply!.text}   ',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: SizedBox()),
                      ]),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Container(
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
                )
              ],
            ),
          );
        }
      }
    }
  }
}
