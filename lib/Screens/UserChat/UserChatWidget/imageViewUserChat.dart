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

import '../../../Utils/text_filed/app_font.dart';
import '../../Information/UserChatInformation/user_chat_information.dart';
import '../../chat_screen.dart';
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
        if(widget.model!.replyId == '0'){
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
                          placeholder: (context, url) =>
                              Container(
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
                     InkWell(
                       child: ConstrainedBox(
                         constraints: BoxConstraints(maxWidth: width / 1.7),
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
                                     placeholder: (context, url) =>
                                         Container(
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
                           SizedBox(width: 140,),
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
                       InkWell(
                         child: ConstrainedBox(
                           constraints: BoxConstraints(maxWidth: width / 1.7),
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
                                       placeholder: (context, url) =>
                                           Container(
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
                             SizedBox(width: 140,),
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
                         InkWell(
                           child: ConstrainedBox(
                             constraints: BoxConstraints(maxWidth: width / 1.7),
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
                                         placeholder: (context, url) =>
                                             Container(
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
                           InkWell(
                             child: ConstrainedBox(
                               constraints: BoxConstraints(maxWidth: width / 1.7),
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
                                           placeholder: (context, url) =>
                                               Container(
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
                             InkWell(
                               child: ConstrainedBox(
                                 constraints: BoxConstraints(maxWidth: width / 1.7),
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
                                             placeholder: (context, url) =>
                                                 Container(
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
                           placeholder: (context, url) =>
                               Container(
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
         }
        }
        /// for user reply
    } else {
      if(widget.model!.replyId == '0'){
        return InkWell(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width / 1.5),
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width / 1.5),
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
                )
              ],
            ),
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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width / 1.5),
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
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: width / 1.5),
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
                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
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
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width / 1.5),
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
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: width / 1.5),
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
              Column(
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
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width / 1.5),
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
              )
            ],
          );
        }
      }

    }
  }
}
