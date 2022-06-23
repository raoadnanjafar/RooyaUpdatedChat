import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/Models/UserChatModel.dart';
import 'package:rooya/Screens/Information/UserChatInformation/user_chat_information.dart';
import 'package:rooya/Utils/UserDataService.dart';
import 'package:rooya/Utils/primary_color.dart';
import 'package:rooya/Utils/text_filed/app_font.dart';

import '../../../ApiConfig/ApiUtils.dart';
import '../../../Models/UserStoriesModel.dart';
import '../../../Utils/StoryViewPage.dart';
import '../UserChat.dart';
import '../UserCommonWidget/ProfileImage_common.dart';
import '../UserCommonWidget/ReplyUserNameCommon.dart';
import '../UserCommonWidget/TextReturnCommon.dart';
import '../UserCommonWidget/TimeReturnCommon.dart';

class TextUserChat extends StatefulWidget {
  final Messages? model;
  final bool? fromGroup;
  const TextUserChat({Key? key, this.model, this.fromGroup}) : super(key: key);

  @override
  _TextUserChatState createState() => _TextUserChatState();
}

class _TextUserChatState extends State<TextUserChat> {
  @override
  Widget build(BuildContext context) {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse("${widget.model!.time}") * 1000);
    if (widget.model!.position != 'right') {
      if (widget.model!.storyId != '0') {
        return InkWell(
            onTap: () {
              context.pushTransparentRoute(StoryViewPage(
                userStories: UserStoryModel(
                    firstName: '${widget.model!.messageUser!.fName}',
                    lastName: '${widget.model!.messageUser!.lName}',
                    userId: '${widget.model!.messageUser!.userId}',
                    stories: [Stories.fromJson(widget.model!.story!.toJson())]),
                isAdmin: storage.read('userID') == '${widget.model!.story!.userId}' ? true : false,
              ));
            },
            child: Column(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: width / 1.8, maxWidth: width / 1.8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Stack(
                              children: [
                                Container(
                                  height: height * 0.3,
                                  width: width * 0.5,
                                  child: widget.model!.story == null
                                      ? SizedBox()
                                      : Image.network(
                                          '${widget.model!.story!.thumbnail}',
                                          fit: BoxFit.cover,
                                        ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: buttonColor, width: 1)),
                                ),
                                Container(
                                  height: height * 0.3,
                                  width: width * 0.5,
                                  decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                ),
                                Positioned(
                                    top: 120,
                                    left: 50,
                                    child: Text(
                                      'View Story',
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ])),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   child: ConstrainedBox(
                        //     constraints: BoxConstraints(
                        //       maxWidth: width / 1.8,
                        //     ),
                        //     child: Container(
                        //       decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(16)),
                        //       child: InkWell(
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text('${widget.model!.text}', style: TextStyle(color: Colors.white,
                        //             fontSize: 16,)),
                        //         ),
                        //         onTap: () {
                        //           context.pushTransparentRoute(StoryViewPage(
                        //             userStories: UserStoryModel(
                        //                 firstName: '${widget.model!.messageUser!.fName}',
                        //                 lastName: '${widget.model!.messageUser!.lName}',
                        //                 userId: '${widget.model!.messageUser!.userId}',
                        //                 stories: [Stories.fromJson(widget.model!.story!.toJson())]),
                        //             isAdmin: storage.read('userID') == '${widget.model!.story!.userId}' ? true : false,
                        //           ));
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    )),
                Container(
                  width: 220,
                  decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('${widget.model!.text}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )),
                        TimeRetuernCommon(fromGroup: widget.fromGroup, model: widget.model)
                      ],
                    ),
                  ),
                )
              ],
            ));
      }
      if (widget.model!.replyId == '0') {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileImageUserCommon(fromGroup: widget.fromGroup, model: widget.model),
            SizedBox(
              width: 5,
            ),
            Container(
              padding: EdgeInsets.all(width / 30),
              decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  ReplyUserName(fromGroup: widget.fromGroup, model: widget.model),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width / 1.5),
                    child: Text(
                      '${widget.model!.text}',
                      //  decrypString(
                      //      encript: '${widget.model!.text}',
                      //      pass: widget.model!.time),
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: height / 100,
                  ),
                  TimeRetuernCommon(fromGroup: widget.fromGroup, model: widget.model)
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ],
        );
      } else {
        if (widget.model!.reply!.type == 'video') {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImageUserCommon(fromGroup: widget.fromGroup, model: widget.model),
              SizedBox(
                width: 5,
              ),
              Container(
                // padding: EdgeInsets.only(right: width / 30, bottom: width / 30),
                decoration: BoxDecoration(color: Color(0xffF3F3F3), borderRadius: BorderRadius.circular(8)),
                child: Column(
                  children: [
                    ReplyUserName(fromGroup: widget.fromGroup, model: widget.model),
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
                            Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                style: TextStyle(color: Colors.blue)),
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
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Stack(
                              children: [
                                Image.network('https://xd.rooya.com/${widget.model!.reply!.thumb}', fit: BoxFit.fill),
                                Positioned(
                                    top: 12,
                                    child: Icon(
                                      Icons.play_circle_filled,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: width / 1.5),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          '${widget.model!.text}',
                          //  decrypString(
                          //      encript: '${widget.model!.text}',
                          //      pass: widget.model!.time),
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 100,
                    ),
                    TimeRetuernCommon(fromGroup: widget.fromGroup, model: widget.model)
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ],
          );
        } else {
          if (widget.model!.reply!.type == 'image') {
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
                SizedBox(
                  width: 5,
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
                              Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                  style: TextStyle(color: Colors.blue)),
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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width / 1.5),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            '${widget.model!.text}',
                            //  decrypString(
                            //      encript: '${widget.model!.text}',
                            //      pass: widget.model!.time),
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height / 100,
                      ),
                      Row(
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
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ],
            );
          } else {
            if (widget.model!.reply!.type == 'file') {
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
                  SizedBox(
                    width: 5,
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
                                    style:
                                        TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold, fontFamily: AppFonts.segoeui, fontSize: 12),
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
                                Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                    style: TextStyle(color: Colors.blue)),
                                Row(
                                  children: [
                                    Icon(Icons.attach_file),
                                    SizedBox(
                                      width: 5,
                                    ),
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
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: width / 1.5),
                          child: Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              '${widget.model!.text}',
                              //  decrypString(
                              //      encript: '${widget.model!.text}',
                              //      pass: widget.model!.time),
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        Row(
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
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              );
            } else {
              if (widget.model!.reply!.type == 'audio') {
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
                    SizedBox(
                      width: 5,
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
                                      style: TextStyle(
                                          color: Colors.deepPurple, fontWeight: FontWeight.bold, fontFamily: AppFonts.segoeui, fontSize: 12),
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
                                  Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                      style: TextStyle(color: Colors.blue)),
                                  Container(
                                    //width: 50,
                                    //color: Colors.black,
                                    child: Row(
                                      children: [Icon(Icons.mic), Text('Voice message')],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width / 1.5),
                            child: Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                '${widget.model!.text}',
                                //  decrypString(
                                //      encript: '${widget.model!.text}',
                                //      pass: widget.model!.time),
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 100,
                          ),
                          Row(
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
            SizedBox(
              width: 5,
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
                          Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                              style: TextStyle(color: Colors.blue)),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width / 1.5, minWidth: 30),
                            child: Text(
                              '${widget.model!.reply!.text}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width / 1.5),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        '${widget.model!.text}',
                        //  decrypString(
                        //      encript: '${widget.model!.text}',
                        //      pass: widget.model!.time),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height / 100,
                  ),
                  Row(
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
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),
          ],
        );
      }

      /// for user site.
    } else {
      if (widget.model!.storyId != '0') {
        return InkWell(
            onTap: () {
              context.pushTransparentRoute(StoryViewPage(
                userStories: UserStoryModel(
                    firstName: '${widget.model!.messageUser!.fName}',
                    lastName: '${widget.model!.messageUser!.lName}',
                    userId: '${widget.model!.messageUser!.userId}',
                    stories: [Stories.fromJson(widget.model!.story!.toJson())]),
                isAdmin: storage.read('userID') == '${widget.model!.story!.userId}' ? true : false,
              ));
            },
            child: Column(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(minWidth: width / 1.8, maxWidth: width / 1.8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: height * 0.3,
                                      width: width * 0.5,
                                      child: widget.model!.story == null
                                          ? SizedBox()
                                          : Image.network(
                                        '${widget.model!.story!.thumbnail}',
                                        fit: BoxFit.cover,
                                      ),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: buttonColor, width: 1)),
                                    ),
                                    Container(
                                      height: height * 0.3,
                                      width: width * 0.5,
                                      decoration:
                                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    Positioned(
                                        top: 120,
                                        left: 50,
                                        child: Text(
                                          'View Story',
                                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                        )),
                                  ],
                                ),
                              ])),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   child: ConstrainedBox(
                        //     constraints: BoxConstraints(
                        //       maxWidth: width / 1.8,
                        //     ),
                        //     child: Container(
                        //       decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(16)),
                        //       child: InkWell(
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(8.0),
                        //           child: Text('${widget.model!.text}', style: TextStyle(color: Colors.white,
                        //             fontSize: 16,)),
                        //         ),
                        //         onTap: () {
                        //           context.pushTransparentRoute(StoryViewPage(
                        //             userStories: UserStoryModel(
                        //                 firstName: '${widget.model!.messageUser!.fName}',
                        //                 lastName: '${widget.model!.messageUser!.lName}',
                        //                 userId: '${widget.model!.messageUser!.userId}',
                        //                 stories: [Stories.fromJson(widget.model!.story!.toJson())]),
                        //             isAdmin: storage.read('userID') == '${widget.model!.story!.userId}' ? true : false,
                        //           ));
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    )),
                Container(
                  width: 220,
                  decoration: BoxDecoration(color: widget.model!.seen != '0'
                      ? returnColorFromString(seenBackColor)
                      : widget.model!.delivered != '0'
                      ? returnColorFromString(receiveBackColor)
                      : returnColorFromString(sentBackColor), borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('${widget.model!.text}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            )),
                        TimeRetuernCommon(fromGroup: widget.fromGroup, model: widget.model)
                      ],
                    ),
                  ),
                )
              ],
            ));
      }
      if (widget.model!.replyId == '0') {
        return Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.010, horizontal: width * 0.030),
          decoration: BoxDecoration(
              color: widget.model!.seen != '0'
                  ? returnColorFromString(seenBackColor)
                  : widget.model!.delivered != '0'
                      ? returnColorFromString(receiveBackColor)
                      : returnColorFromString(sentBackColor),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              // Text(
              //   '${widget.model!.text}',
              //   style: TextStyle(
              //       color: widget.model!.seen != '0'
              //           ? returnColorFromString(seenTextColor)
              //           : widget.model!.delivered != '0'
              //               ? returnColorFromString(receiveTextColor)
              //               : returnColorFromString(sentTextColor),
              //       fontWeight: FontWeight.w300,
              //       fontFamily: AppFonts.segoeui,
              //       fontSize: 14),
              // ),
              TextReplyCommon(model: widget.model, fromGroup: widget.fromGroup),
              SizedBox(
                height: height / 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: width / 50),
                    child: Text(
                      '${dateFormat.format(date)}',
                      style: TextStyle(
                        color: widget.model!.seen != '0'
                            ? returnColorFromString(seenTimeColor)
                            : widget.model!.delivered != '0'
                                ? returnColorFromString(receiveTimeColor)
                                : returnColorFromString(sentTimeColor),
                        fontFamily: AppFonts.segoeui,
                        fontSize: 9.0,
                      ),
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
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      } else {
        if (widget.model!.reply!.type == 'image') {
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
                            Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                style: TextStyle(color: Colors.blue)),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
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
                          ),
                          SizedBox(
                            height: height / 100,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: width / 50),
                                child: Text(
                                  '${dateFormat.format(date)}',
                                  style: TextStyle(
                                    color: widget.model!.seen != '0'
                                        ? returnColorFromString(seenTimeColor)
                                        : widget.model!.delivered != '0'
                                            ? returnColorFromString(receiveTimeColor)
                                            : returnColorFromString(sentTimeColor),
                                    fontFamily: AppFonts.segoeui,
                                    fontSize: 9.0,
                                  ),
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
                          )
                        ],
                      ),
                      padding: EdgeInsets.only(left: width * 0.030, bottom: height * 0.010, right: width * 0.030, top: height * 0.0050),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ],
          );
        } else {
          if (widget.model!.reply!.type == 'file') {
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
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                              Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                  style: TextStyle(color: Colors.blue)),
                              Row(
                                children: [
                                  Icon(Icons.attach_file),
                                  SizedBox(
                                    width: 5,
                                  ),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
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
                            ),
                            SizedBox(
                              height: height / 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: width / 50),
                                  child: Text(
                                    '${dateFormat.format(date)}',
                                    style: TextStyle(
                                      color: widget.model!.seen != '0'
                                          ? returnColorFromString(seenTimeColor)
                                          : widget.model!.delivered != '0'
                                              ? returnColorFromString(receiveTimeColor)
                                              : returnColorFromString(sentTimeColor),
                                      fontFamily: AppFonts.segoeui,
                                      fontSize: 9.0,
                                    ),
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
                            )
                          ],
                        ),
                        padding: EdgeInsets.only(left: width * 0.030, bottom: height * 0.010, right: width * 0.030, top: height * 0.0050),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ],
            );
          } else {
            if (widget.model!.reply!.type == 'video') {
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
                                Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                    style: TextStyle(color: Colors.blue)),
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
                              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Stack(
                                  children: [
                                    Image.network('https://xd.rooya.com/${widget.model!.reply!.thumb}', fit: BoxFit.fill),
                                    Positioned(
                                        top: 12,
                                        child: Icon(
                                          Icons.play_circle_filled,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
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
                              ),
                              SizedBox(
                                height: height / 100,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(left: width / 50),
                                    child: Text(
                                      '${dateFormat.format(date)}',
                                      style: TextStyle(
                                        color: widget.model!.seen != '0'
                                            ? returnColorFromString(seenTimeColor)
                                            : widget.model!.delivered != '0'
                                                ? returnColorFromString(receiveTimeColor)
                                                : returnColorFromString(sentTimeColor),
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 9.0,
                                      ),
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
                              )
                            ],
                          ),
                          padding: EdgeInsets.only(left: width * 0.030, bottom: height * 0.010, right: width * 0.030, top: height * 0.0050),
                        ),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              );
            } else {
              if (widget.model!.reply!.type == 'audio') {
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
                                  Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                                      style: TextStyle(color: Colors.blue)),
                                  Container(
                                    //width: 50,
                                    //color: Colors.black,
                                    child: Row(
                                      children: [Icon(Icons.mic), Text('Voice message')],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
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
                                ),
                                SizedBox(
                                  height: height / 100,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: width / 50),
                                      child: Text(
                                        '${dateFormat.format(date)}',
                                        style: TextStyle(
                                          color: widget.model!.seen != '0'
                                              ? returnColorFromString(seenTimeColor)
                                              : widget.model!.delivered != '0'
                                                  ? returnColorFromString(receiveTimeColor)
                                                  : returnColorFromString(sentTimeColor),
                                          fontFamily: AppFonts.segoeui,
                                          fontSize: 9.0,
                                        ),
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
                                )
                              ],
                            ),
                            padding: EdgeInsets.only(left: width * 0.030, bottom: height * 0.010, right: width * 0.030, top: height * 0.0050),
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
                          Text('${widget.model!.messageUser!.fName} ' + '${widget.model!.messageUser!.lName}   ',
                              style: TextStyle(color: Colors.blue)),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width / 1.5),
                            child: Text(
                              '${widget.model!.reply!.text}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontFamily: AppFonts.segoeui, fontSize: 14),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
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
                        ),
                        SizedBox(
                          height: height / 100,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: width / 50),
                              child: Text(
                                '${dateFormat.format(date)}',
                                style: TextStyle(
                                  color: widget.model!.seen != '0'
                                      ? returnColorFromString(seenTimeColor)
                                      : widget.model!.delivered != '0'
                                          ? returnColorFromString(receiveTimeColor)
                                          : returnColorFromString(sentTimeColor),
                                  fontFamily: AppFonts.segoeui,
                                  fontSize: 9.0,
                                ),
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
                        )
                      ],
                    ),
                    padding: EdgeInsets.only(left: width * 0.030, bottom: height * 0.010, right: width * 0.030, top: height * 0.0050),
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
