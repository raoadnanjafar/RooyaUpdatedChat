import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:rooya/AllDialog/showMessageDetaildDialog.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/BaseURL.dart';
import 'package:rooya/GlobalWidget/FileUploader.dart';
import 'package:rooya/GlobalWidget/Photo_View_Class.dart';
import 'package:rooya/GlobalWidget/SnackBarApp.dart';
import 'package:rooya/Models/GroupModel.dart';
import 'package:rooya/Models/UserChatModel.dart';
import 'package:rooya/Plugins/AudioAnimationSource/record_button.dart';
import 'package:rooya/Plugins/FocusedMenu/focused_menu.dart';
import 'package:rooya/Plugins/FocusedMenu/modals.dart';
import 'package:rooya/Screens/Information/GroupInformation/GroupInformation.dart';
import 'package:rooya/Screens/Information/UserChatInformation/user_chat_information.dart';
import 'package:rooya/Utils/primary_color.dart';
import 'package:rooya/Utils/text_filed/app_font.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../GlobalWidget/ConfirmationDialog.dart';
import '../../Utils/StoryViewPage.dart';
import '../sliver_class/sliver.dart';
import 'UserChatProvider.dart';
import 'package:record/record.dart' as record;
import 'UserChatWidget/AudioChatUser.dart';
import 'UserChatWidget/ContactViewUserChat.dart';
import 'UserChatWidget/DocumentUserChat.dart';
import 'UserChatWidget/LocationViewUserChat.dart';
import 'UserChatWidget/SendSmsView.dart';
import 'UserChatWidget/TextUserChat.dart';
import 'UserChatWidget/VideoUserChat.dart';
import 'UserChatWidget/imageViewUserChat.dart';
import 'UserChatWidget/replyChat.dart';

String seenTextColor = '';
String receiveTextColor = '';
String sentTextColor = '';

String seenCheck = '';
String receiveCheck = '';
String sentCheck = '';

String seenTimeColor = '';
String receiveTimeColor = '';
String sentTimeColor = '';

String seenBackColor = '';
String receiveBackColor = '';
String sentBackColor = '';
GroupModel? groupModelGlobel;
class UserChat extends StatefulWidget {
  final String? groupID;
  final String? profilePic;
  final String? name;
  final bool? fromGroup;
  final String? unseenMessage;
  final bool? blocked;
  final GroupModel? groupModel;

  const UserChat(
      {Key? key,
      this.groupID,
      this.profilePic,
      this.name,
      this.fromGroup = false,
      this.unseenMessage = '0',
      this.blocked = false,
      this.groupModel})
      : super(key: key);

  @override
  _UserChatState createState() => _UserChatState();
}

class _UserChatState extends State<UserChat>
    with SingleTickerProviderStateMixin {
  late AnimationController animcontroller;
  TextEditingController controller = TextEditingController();
  bool isfirst = false;
  DateFormat sdf2 = DateFormat("hh.mm aa");
  DateFormat sdf1 = DateFormat("hh:mm:ss aa");
  var replyModel = Messages().obs;
  var isActivereply = false.obs;
  UserChatProvider? getcontroller;

  String audio_path = '';

  @override
  void initState() {
    if(widget.fromGroup!){
      groupModelGlobel=widget.groupModel!;
    }
    if (storage.read('selectedTab') == '0') {
      seenTextColor = '255,0,0,0';
      receiveTextColor = '255,0,0,0';
      sentTextColor = '255,0,0,0';

      seenCheck = '255,33,150,243';
      receiveCheck = '100,0,0,0';
      sentCheck = '100,0,0,0';

      seenTimeColor = '100,0,0,0';
      receiveTimeColor = '100,0,0,0';
      sentTimeColor = '100,0,0,0';

      seenBackColor = '255,219,247,199';
      receiveBackColor = '255,219,247,199';
      sentBackColor = '255,219,247,199';
    } else {
      seenTextColor = storage.read('seenTextColor');
      receiveTextColor = storage.read('receiveTextColor');
      sentTextColor = storage.read('sentTextColor');

      seenCheck = storage.read('seenCheck');
      receiveCheck = storage.read('receiveCheck');
      sentCheck = storage.read('sentCheck');

      seenTimeColor = storage.read('seenTimeColor');
      receiveTimeColor = storage.read('receiveTimeColor');
      sentTimeColor = storage.read('sentTimeColor');

      seenBackColor = storage.read('seenBackColor');
      receiveBackColor = storage.read('receiveBackColor');
      sentBackColor = storage.read('sentBackColor');
    }
    print('group id =${widget.groupID}');
    getcontroller =
        Get.put(UserChatProvider(), tag: '${widget.groupID}' + 'fromGroup');
    getcontroller!
        .onConnectScocket(groupID: widget.groupID, fromGroup: widget.fromGroup);
    getcontroller!
        .getAllMessage(userID: widget.groupID, fromGroup: widget.fromGroup);
    getcontroller!.checkTypnigStatus(
      groupId: widget.groupID,
    );
    super.initState();
    animcontroller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    getcontroller!.block_user.value = widget.blocked!;
    autoScrollController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: scrollDirection);
    if (widget.fromGroup!) {
      for (var i in widget.groupModel!.parts!) {
        listofUsers.add({
          'id': '${i.userId}',
          'display': '${i.username}',
          'photo': '${i.avatar}',
          'username': '${i.firstName} ${i.lastName}',
        });
      }
    }
  }

  GlobalKey<FlutterMentionsState> key = GlobalKey<FlutterMentionsState>();
  @override
  void dispose() {
    getcontroller!.leaveRoom(groupId: widget.groupID);
    getcontroller!.searchText.value = '';
    animcontroller.dispose();
    getcontroller!.isReciverTyping.value = false;
    getcontroller!.isOnline.value = false;
    super.dispose();
  }

  var listofUsers = <Map<String, String>>[];
  var selectedOneToOneChat = <Messages>[].obs;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isReply = false;

  final scrollDirection = Axis.vertical;
  AutoScrollController? autoScrollController;
  List<List<int>>? randomList;

  Future _scrollToIndex(int? index) async {
    print('old message index is =$index');
    await autoScrollController!
        .scrollToIndex(index!, preferPosition: AutoScrollPosition.begin);
    Future.delayed(Duration(seconds: 1), () {
      fadeIndex = -1;
    });
  }

  int fadeIndex = -1;

  Widget fadeChild({Widget? child, bool? animate}) {
    if (animate!) {
      return Flash(
        child: child!,
      );
    } else {
      return child!;
    }
  }

  bool emojiShowing = false;

  _onEmojiSelected(Emoji emoji) {
    key.currentState!.controller!
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: key.currentState!.controller!.markupText.length));
  }

  _onBackspacePressed() {
    key.currentState!.controller!
      ..text = controller.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(TextPosition(
          offset: key.currentState!.controller!.markupText.length));
  }

  final _focusNode = FocusNode();
  final _textFieldKey = UniqueKey();
  TextEditingController inputTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = Get.height;
    var width = Get.width;
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              child: Column(
                children: [
                  Material(
                      child: selectedOneToOneChat.isNotEmpty
                          ? Container(
                              decoration: BoxDecoration(color: primaryColor),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        selectedOneToOneChat.value =
                                            <Messages>[];
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.clear)),
                                  Text('${selectedOneToOneChat.length}'),
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.redo,
                                          size: 20,
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            selectedOneToOneChat.length == 1
                                                ? true
                                                : false,
                                        child: IconButton(
                                          onPressed: () {
                                            Clipboard.setData(ClipboardData(
                                                text:
                                                    "${selectedOneToOneChat[0].text}"));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text("Coped"),
                                                    duration:
                                                        Duration(seconds: 1)));
                                            selectedOneToOneChat.value =
                                                <Messages>[];
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async {
                                          await showAlertDialog(
                                              context: context,
                                              cancel: () {
                                                Navigator.of(context).pop();
                                              },
                                              done: () {
                                                for (var i = 0;
                                                    i <
                                                        selectedOneToOneChat
                                                            .length;
                                                    i++) {
                                                  Map payLoad = {
                                                    'server_key': serverKey,
                                                    'message_id':
                                                        '${selectedOneToOneChat[i].id}'
                                                  };
                                                  ApiUtils.removeMessageApi(
                                                      map: payLoad);
                                                  getcontroller!.userChat
                                                      .remove(
                                                          selectedOneToOneChat[
                                                              i]);
                                                }
                                                selectedOneToOneChat.clear();
                                                Navigator.pop(context);
                                                setState(() {});
                                              });
                                        },
                                        icon: Icon(
                                          CupertinoIcons.delete,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  ))
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                storyIds.contains(widget.groupID)
                                    ? CircularProfileAvatar(
                                        '${widget.profilePic}',
                                        radius: height / 40,
                                        borderWidth: 2,
                                        borderColor: buttonColor,
                                        backgroundColor: Colors.blueGrey[100]!,
                                        onTap: () {
                                          int i = storyIds.indexWhere(
                                              (element) =>
                                                  element ==
                                                  '${widget.groupID}');
                                          context.pushTransparentRoute(
                                              StoryViewPage(
                                            userStories: allstoryList[i],
                                            isAdmin: storage.read('userID') ==
                                                    '${widget.groupID}'
                                                ? true
                                                : false,
                                          ));
                                        },
                                      )
                                    : CircularProfileAvatar(
                                        '${widget.profilePic}',
                                        borderColor: Colors.black26,
                                        borderWidth: 0.5,
                                        onTap: () {
                                          Get.to(Photo_View_Class(
                                            url: '${widget.profilePic}',
                                          ));
                                        },
                                        radius: height / 40,
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!widget.fromGroup!) {
                                        Get.to(UserChatInformation(
                                            userID: widget.groupID));
                                      } else {
                                        Get.to(GroupInformation(
                                          groupModel: widget.groupModel,
                                          groupID: '',
                                        ));
                                      }
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.name}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Obx(
                                          () => getcontroller!
                                                  .isReciverTyping.value
                                              ? Text(
                                                  'Typing ...',
                                                  style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.black26),
                                                )
                                              : getcontroller!.isOnline.value
                                                  ? Text(
                                                      'Online',
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          color:
                                                              Colors.black26),
                                                    )
                                                  : SizedBox(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                widget.fromGroup!
                                    ? PopupMenuButton(
                                        child: Icon(Icons.more_vert),
                                        itemBuilder: (context) {
                                          return ['Leave Group'].map((e) {
                                            return PopupMenuItem(
                                              value: e,
                                              onTap: () async {
                                                Future.delayed(
                                                    Duration(seconds: 0),
                                                    () async {
                                                        Map map = {
                                                          'server_key':
                                                          serverKey,
                                                          'type': 'leave',
                                                          'id': widget.groupID
                                                        };
                                                        bool v = await ApiUtils
                                                            .leaveGroup(
                                                            map: map);
                                                        if (v) {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          // snackBarFailer(
                                                          //     'Admin did not leave the group');
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                  setState(() {});
                                                });
                                              },
                                              child: Text('$e'),
                                            );
                                          }).toList();
                                        },
                                      )
                                    : PopupMenuButton(
                                        child: Icon(Icons.more_vert),
                                        itemBuilder: (context) {
                                          return ['Block'].map((e) {
                                            return PopupMenuItem(
                                              value: e,
                                              onTap: () async {
                                                Future.delayed(Duration(),
                                                    () async {
                                                  await showAlertDialog(
                                                      context: context,
                                                      content:
                                                          'You want to block the User?',
                                                      cancel: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      done: () async {
                                                        Map map = {
                                                          'server_key':
                                                              serverKey,
                                                          'user_id':
                                                              widget.groupID,
                                                          'block_action':
                                                              'block'
                                                        };
                                                        await ApiUtils
                                                            .blockUnblockUser(
                                                                map: map);
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                  setState(() {});
                                                });
                                              },
                                              child: Text('$e'),
                                            );
                                          }).toList();
                                        },
                                      ),
                                SizedBox(width: 5),
                              ],
                            ),
                      elevation: 1),
                  Expanded(
                      child: Obx(() => Container(
                            child: ListView.builder(
                              scrollDirection: scrollDirection,
                              controller: autoScrollController,
                              itemBuilder: (c, i) {
                                String? extension =
                                    '${getcontroller!.userChat[i].type}';
                                return AutoScrollTag(
                                    key: ValueKey(i),
                                    controller: autoScrollController!,
                                    index: i,
                                    child: fadeChild(
                                      animate: fadeIndex == i ? true : false,
                                      child: SwipeTo(
                                        child:
                                            getcontroller!
                                                        .userChat[i].position !=
                                                    'right'
                                                ? Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: width / 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          selectedOneToOneChat
                                                                  .isNotEmpty
                                                              ? !selectedOneToOneChat
                                                                      .contains(
                                                                          getcontroller!
                                                                              .userChat[i])
                                                                  ? Container(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      decoration: BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border: Border.all(
                                                                              width: 1,
                                                                              color: buttonColor)),
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          20,
                                                                      width: 20,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .check_circle,
                                                                        color:
                                                                            buttonColor,
                                                                      ),
                                                                    )
                                                              : SizedBox(),
                                                          SizedBox(
                                                            width: width / 100,
                                                          ),
                                                          IntrinsicWidth(
                                                            child:
                                                                FocusedMenuHolder(
                                                              blurSize: 5.0,
                                                              menuItemExtent:
                                                                  45,
                                                              enableMenu:
                                                                  selectedOneToOneChat
                                                                          .isEmpty
                                                                      ? true
                                                                      : false,
                                                              onCneTapMenuItems: <
                                                                  FocusedMenuItem>[
                                                                FocusedMenuItem(
                                                                    title: Text(
                                                                        "Info"),
                                                                    onPressed:
                                                                        () {},
                                                                    trailingIcon:
                                                                        Icon(
                                                                      CupertinoIcons
                                                                          .info,
                                                                      size: 20,
                                                                    )),
                                                                FocusedMenuItem(
                                                                    title: Text(
                                                                        "Reply"),
                                                                    onPressed:
                                                                        () {
                                                                      replyModel
                                                                              .value =
                                                                          getcontroller!
                                                                              .userChat[i];
                                                                      isActivereply
                                                                              .value =
                                                                          true;
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    trailingIcon: Icon(
                                                                        CupertinoIcons
                                                                            .reply,
                                                                        size:
                                                                            20)),
                                                                FocusedMenuItem(
                                                                    title: Text(
                                                                        "Forward"),
                                                                    onPressed:
                                                                        () {
                                                                      if (!selectedOneToOneChat
                                                                          .contains(
                                                                              getcontroller!.userChat[i])) {
                                                                        selectedOneToOneChat
                                                                            .add(getcontroller!.userChat[i]);
                                                                      } else {
                                                                        selectedOneToOneChat
                                                                            .remove(getcontroller!.userChat[i]);
                                                                      }
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    trailingIcon: Icon(
                                                                        CupertinoIcons
                                                                            .goforward,
                                                                        size:
                                                                            20)),
                                                                FocusedMenuItem(
                                                                    title: Text(
                                                                        "Copy"),
                                                                    onPressed:
                                                                        () {
                                                                      Clipboard.setData(
                                                                          ClipboardData(
                                                                              text: "${getcontroller!.userChat[i].text}"));
                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                          content: Text(
                                                                              'Copyed'),
                                                                          duration:
                                                                              Duration(seconds: 1)));
                                                                    },
                                                                    trailingIcon: Icon(
                                                                        CupertinoIcons
                                                                            .square_on_circle,
                                                                        size:
                                                                            20)),
                                                                FocusedMenuItem(
                                                                    title: Text(
                                                                      "Delete",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      await showAlertDialog(
                                                                          context:
                                                                              context,
                                                                          cancel:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          done:
                                                                              () async {
                                                                            Map payLoad =
                                                                                {
                                                                              'server_key': serverKey,
                                                                              'message_id': '${getcontroller!.userChat[i].id}'
                                                                            };
                                                                            ApiUtils.removeMessageApi(map: payLoad);
                                                                            getcontroller!.userChat.removeAt(i);
                                                                            setState(() {});
                                                                            Navigator.of(context).pop();
                                                                          });
                                                                      setState(
                                                                          () {});
                                                                    },
                                                                    trailingIcon:
                                                                        Icon(
                                                                      CupertinoIcons
                                                                          .delete,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .red,
                                                                    )),
                                                              ],
                                                              menuWidth:
                                                                  width * 0.4,
                                                              animateMenuItems:
                                                                  false,
                                                              blurBackgroundColor:
                                                                  Colors
                                                                      .black54,
                                                              menuOffset: 10,
                                                              onPressed: () {
                                                                print(
                                                                    'Clicked');
                                                                if (getcontroller!
                                                                        .userChat[
                                                                            i]
                                                                        .replyId !=
                                                                    '0') {
                                                                  print(
                                                                      'in first');
                                                                  isActivePositionTap
                                                                          .value =
                                                                      false;
                                                                  _scrollToIndex(getcontroller!
                                                                      .userChat
                                                                      .indexWhere((element) =>
                                                                          element
                                                                              .replyId ==
                                                                          getcontroller!
                                                                              .userChat[i]
                                                                              .id));
                                                                  fadeIndex = getcontroller!
                                                                      .userChat
                                                                      .indexWhere((element) =>
                                                                          element
                                                                              .replyId ==
                                                                          getcontroller!
                                                                              .userChat[i]
                                                                              .id);
                                                                  setState(
                                                                      () {});
                                                                  Future.delayed(
                                                                      Duration(
                                                                          seconds:
                                                                              1),
                                                                      () {
                                                                    fadeIndex =
                                                                        -1;
                                                                    isActivePositionTap
                                                                            .value =
                                                                        true;
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                } else {
                                                                  if (selectedOneToOneChat
                                                                      .isNotEmpty) {
                                                                    if (!selectedOneToOneChat
                                                                        .contains(
                                                                            getcontroller!.userChat[i])) {
                                                                      selectedOneToOneChat.add(
                                                                          getcontroller!
                                                                              .userChat[i]);
                                                                      print(
                                                                          'lenth is = ${selectedOneToOneChat.length}');
                                                                    } else {
                                                                      print(
                                                                          'lenth is = ${selectedOneToOneChat.length}');
                                                                      selectedOneToOneChat
                                                                          .remove(
                                                                              getcontroller!.userChat[i]);
                                                                      print(
                                                                          'lenth is = ${selectedOneToOneChat.length}');
                                                                    }
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                }
                                                              },
                                                              onlongPress: () {
                                                                if (!selectedOneToOneChat
                                                                    .contains(
                                                                        getcontroller!
                                                                            .userChat[i])) {
                                                                  selectedOneToOneChat.add(
                                                                      getcontroller!
                                                                          .userChat[i]);
                                                                } else {
                                                                  selectedOneToOneChat.remove(
                                                                      getcontroller!
                                                                          .userChat[i]);
                                                                }
                                                                setState(() {});
                                                              },
                                                              openWithTap: true,
                                                              child: Column(
                                                                children: [
                                                                  ''.contains(
                                                                          'Contacts#=-:')
                                                                      ? ContactViewChat()
                                                                      : ''.contains(
                                                                              'longitude')
                                                                          ? LocationViewUserChat()
                                                                          : extension.contains('image')
                                                                              ? ImageViewUserChat(
                                                                                  model: getcontroller!.userChat[i],
                                                                                  fromGroup: widget.fromGroup,
                                                                                )
                                                                              : extension.contains('video')
                                                                                  ? VideoUserChat(
                                                                                      model: getcontroller!.userChat[i],
                                                                                      fromGroup: widget.fromGroup,
                                                                                    )
                                                                                  : extension.contains('audio')
                                                                                      ? AudioChatUser(
                                                                                          model: getcontroller!.userChat[i],
                                                                                          fromGroup: widget.fromGroup,
                                                                                        )
                                                                                      : extension.contains('file')
                                                                                          ? DocumentUserChat(
                                                                                              model: getcontroller!.userChat[i],
                                                                                              fromGroup: widget.fromGroup,
                                                                                            )
                                                                                          : TextUserChat(
                                                                                              model: getcontroller!.userChat[i],
                                                                                              fromGroup: widget.fromGroup,
                                                                                            ),
                                                                  SizedBox(
                                                                    height:
                                                                        height /
                                                                            200,
                                                                  ),
                                                                ],
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: width / 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          selectedOneToOneChat
                                                                  .isNotEmpty
                                                              ? Expanded(
                                                                  child: Row(
                                                                    children: [
                                                                      !selectedOneToOneChat
                                                                              .contains(getcontroller!.userChat[i])
                                                                          ? Container(
                                                                              height: 20,
                                                                              width: 20,
                                                                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1, color: buttonColor)),
                                                                            )
                                                                          : Container(
                                                                              height: 20,
                                                                              width: 20,
                                                                              child: Icon(
                                                                                Icons.check_circle,
                                                                                color: buttonColor,
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                          SizedBox(
                                                            width: width / 100,
                                                          ),
                                                          ConstrainedBox(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                          width /
                                                                              1.3),
                                                              child:
                                                                  IntrinsicWidth(
                                                                child:
                                                                    FocusedMenuHolder(
                                                                  blurSize: 5.0,
                                                                  menuItemExtent:
                                                                      45,
                                                                  menuWidth:
                                                                      width *
                                                                          0.4,
                                                                  animateMenuItems:
                                                                      false,
                                                                  enableMenu:
                                                                      selectedOneToOneChat
                                                                              .isEmpty
                                                                          ? true
                                                                          : false,
                                                                  menuOffset:
                                                                      10,
                                                                  onlongPress:
                                                                      () async {
                                                                    if (!selectedOneToOneChat
                                                                        .contains(
                                                                            getcontroller!.userChat[i])) {
                                                                      selectedOneToOneChat.add(
                                                                          getcontroller!
                                                                              .userChat[i]);
                                                                    } else {
                                                                      selectedOneToOneChat
                                                                          .remove(
                                                                              getcontroller!.userChat[i]);
                                                                    }
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  onCneTapMenuItems: <
                                                                      FocusedMenuItem>[
                                                                    FocusedMenuItem(
                                                                        title: Text(
                                                                            "Info"),
                                                                        onPressed:
                                                                            () {
                                                                          showMessageDetailedDialog(
                                                                              context: context,
                                                                              model: getcontroller!.userChat[i]);
                                                                        },
                                                                        trailingIcon:
                                                                            Icon(
                                                                          CupertinoIcons
                                                                              .info,
                                                                          size:
                                                                              20,
                                                                        )),
                                                                    FocusedMenuItem(
                                                                        title: Text(
                                                                            "Reply"),
                                                                        onPressed:
                                                                            () {
                                                                          replyModel.value =
                                                                              getcontroller!.userChat[i];
                                                                          isActivereply.value =
                                                                              true;
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        trailingIcon: Icon(
                                                                            CupertinoIcons
                                                                                .reply,
                                                                            size:
                                                                                20)),
                                                                    FocusedMenuItem(
                                                                        title: Text(
                                                                            "Forward"),
                                                                        onPressed:
                                                                            () {
                                                                          if (!selectedOneToOneChat
                                                                              .contains(getcontroller!.userChat[i])) {
                                                                            selectedOneToOneChat.add(getcontroller!.userChat[i]);
                                                                          } else {
                                                                            selectedOneToOneChat.remove(getcontroller!.userChat[i]);
                                                                          }
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        trailingIcon: Icon(
                                                                            CupertinoIcons
                                                                                .goforward,
                                                                            size:
                                                                                20)),
                                                                    FocusedMenuItem(
                                                                        title: Text(
                                                                            'Copy'),
                                                                        onPressed:
                                                                            () {
                                                                          Clipboard.setData(
                                                                              ClipboardData(text: "${getcontroller!.userChat[i].text}"));
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(SnackBar(
                                                                            content:
                                                                                Text('Copyed'),
                                                                            duration:
                                                                                Duration(seconds: 1),
                                                                          ));
                                                                        },
                                                                        trailingIcon: Icon(
                                                                            CupertinoIcons
                                                                                .square_on_circle,
                                                                            size:
                                                                                20)),
                                                                    FocusedMenuItem(
                                                                        title:
                                                                            Text(
                                                                          "Delete",
                                                                          style:
                                                                              TextStyle(color: Colors.red),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          await showAlertDialog(
                                                                              context: context,
                                                                              cancel: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              done: () async {
                                                                                Map payLoad = {
                                                                                  'server_key': serverKey,
                                                                                  'message_id': '${getcontroller!.userChat[i].id}'
                                                                                };
                                                                                ApiUtils.removeMessageApi(map: payLoad);
                                                                                getcontroller!.userChat.removeAt(i);
                                                                                setState(() {});
                                                                                Navigator.of(context).pop();
                                                                              });
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        trailingIcon:
                                                                            Icon(
                                                                          CupertinoIcons
                                                                              .delete,
                                                                          size:
                                                                              20,
                                                                          color:
                                                                              Colors.red,
                                                                        )),
                                                                  ],
                                                                  onPressed:
                                                                      () {
                                                                    if (getcontroller!
                                                                            .userChat[i]
                                                                            .replyId !=
                                                                        '0') {
                                                                      isActivePositionTap
                                                                              .value =
                                                                          false;
                                                                      _scrollToIndex(getcontroller!.userChat.indexWhere((element) =>
                                                                          element
                                                                              .replyId ==
                                                                          getcontroller!
                                                                              .userChat[i]
                                                                              .id));
                                                                      fadeIndex = getcontroller!.userChat.indexWhere((element) =>
                                                                          element
                                                                              .replyId ==
                                                                          getcontroller!
                                                                              .userChat[i]
                                                                              .id);
                                                                      setState(
                                                                          () {});
                                                                      Future.delayed(
                                                                          Duration(
                                                                              seconds: 1),
                                                                          () {
                                                                        fadeIndex =
                                                                            -1;
                                                                        isActivePositionTap.value =
                                                                            true;
                                                                        setState(
                                                                            () {});
                                                                      });
                                                                    } else {
                                                                      if (selectedOneToOneChat
                                                                          .isNotEmpty) {
                                                                        if (!selectedOneToOneChat
                                                                            .contains(getcontroller!.userChat[i])) {
                                                                          selectedOneToOneChat
                                                                              .add(getcontroller!.userChat[i]);
                                                                        } else {
                                                                          selectedOneToOneChat
                                                                              .remove(getcontroller!.userChat[i]);
                                                                        }
                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    }
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      ''.contains(
                                                                              'Contacts#=-:')
                                                                          ? ContactViewChat()
                                                                          : ''.contains('longitude')
                                                                              ? LocationViewUserChat()
                                                                              : extension.contains('image')
                                                                                  ? ImageViewUserChat(
                                                                                      model: getcontroller!.userChat[i],
                                                                                      fromGroup: widget.fromGroup,
                                                                                    )
                                                                                  : extension.contains('video')
                                                                                      ? VideoUserChat(
                                                                                          model: getcontroller!.userChat[i],
                                                                                          fromGroup: widget.fromGroup,
                                                                                        )
                                                                                      : extension.contains('audio')
                                                                                          ? AudioChatUser(
                                                                                              model: getcontroller!.userChat[i],
                                                                                              fromGroup: widget.fromGroup,
                                                                                            )
                                                                                          : extension.contains('file')
                                                                                              ? DocumentUserChat(
                                                                                                  model: getcontroller!.userChat[i],
                                                                                                  fromGroup: widget.fromGroup,
                                                                                                )
                                                                                              : TextUserChat(
                                                                                                  model: getcontroller!.userChat[i],
                                                                                                  fromGroup: widget.fromGroup,
                                                                                                ),
                                                                      SizedBox(
                                                                        height: height /
                                                                            200,
                                                                      ),
                                                                    ],
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                  ),
                                                                ),
                                                              )),
                                                          SizedBox(
                                                            width: width / 100,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                        onRightSwipe: () {
                                          replyModel.value =
                                              getcontroller!.userChat[i];
                                          isActivereply.value = true;
                                          setState(() {});
                                        },
                                        onLeftSwipe: () {
                                          //smsInformation(context: context);
                                        },
                                        leftSwipeWidget: SizedBox(),
                                        iconOnRightSwipe: CupertinoIcons.reply,
                                      ),
                                    ),
                                    highlightColor: Colors.black);
                              },
                              reverse: true,
                              itemCount: getcontroller!.userChat.length,
                            ),
                            padding: EdgeInsets.only(
                                left: width / 25, right: width / 25),
                          ))),
                  isActivereply.value == true
                      ? Container(
                          decoration: BoxDecoration(color: Colors.blueGrey[50]),
                          child: Row(
                            children: [
                              Container(
                                height: height * 0.070,
                                width: 3,
                                decoration:
                                    BoxDecoration(color: Colors.deepPurple),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    replyModel.value.userData != null
                                        ? Text(
                                            storage.read('userID') !=
                                                    replyModel
                                                        .value.userData!.userId
                                                        .toString()
                                                ? replyModel.value.userData!
                                                        .firstName!.isEmpty
                                                    ? '${replyModel.value.userData!.username}'
                                                    : '${replyModel.value.userData!.firstName} ${replyModel.value.userData!.lastName}'
                                                : 'You',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.deepPurple),
                                          )
                                        : storage.read('userID') !=
                                                replyModel
                                                    .value.messageUser!.userId
                                                    .toString()
                                            ? CircularProfileAvatar(
                                                '',
                                                radius: 12,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${replyModel.value.messageUser!.avatar!}",
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                                imageFit: BoxFit.cover,
                                              )
                                            : Text(
                                                'You',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.deepPurple),
                                              ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text(
                                        replyModel.value.type == 'text'
                                            ? '${replyModel.value.text}'
                                            : '${replyModel.value.type}',
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        replyModel.value = Messages();
                                        isActivereply.value = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                        child: Icon(
                                          Icons.close,
                                          size: 17,
                                        ),
                                        decoration: BoxDecoration(
                                            color: Colors.black12,
                                            shape: BoxShape.circle),
                                        padding: EdgeInsets.all(3),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  selectedOneToOneChat.isNotEmpty
                      ? Container(
                          height: height * 0.050,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(color: primaryColor),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              selectedOneToOneChat.length > 1
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        replyModel.value =
                                            selectedOneToOneChat[0];
                                        isActivereply.value = true;
                                        selectedOneToOneChat.clear();
                                        setState(() {});
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.undo),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            'Reply',
                                            style: TextStyle(fontSize: 13),
                                          )
                                        ],
                                      ),
                                    ),
                              InkWell(
                                onTap: () async {
                                  var listofmap = [];
                                  await getcontroller!.getFriendList();
                                  showMaterialModalBottomSheet(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                        builder: (context, setState) {
                                      return Container(
                                        height: height - 100,
                                        width: width,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          color: Colors.blue,
                                                          fontFamily:
                                                              AppFonts.segoeui),
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  listofmap.isNotEmpty
                                                      ? InkWell(
                                                          child: Text(
                                                            'Forward',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                color:
                                                                    Colors.blue,
                                                                fontFamily:
                                                                    AppFonts
                                                                        .segoeui),
                                                          ),
                                                          onTap: () {
                                                            for (var i
                                                                in listofmap) {
                                                              for (var j
                                                                  in selectedOneToOneChat) {
                                                                Map map = {
                                                                  'server_key':
                                                                      serverKey,
                                                                  'id':
                                                                      '${j.id}',
                                                                  'recipient_id':
                                                                      i
                                                                };
                                                                ApiUtils
                                                                    .sendMessagepost(
                                                                        map:
                                                                            map);
                                                              }
                                                            }
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          },
                                                        )
                                                      : SizedBox()
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: getcontroller!
                                                    .friendList.length,
                                                itemBuilder: (context, i) =>
                                                    Column(
                                                  children: [
                                                    ListTile(
                                                      leading:
                                                          CircularProfileAvatar(
                                                        '',
                                                        radius: 23,
                                                        child: Image.network(
                                                          '${getcontroller!.friendList[i].avatar}',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      title: Text(
                                                        getcontroller!
                                                                .friendList[i]
                                                                .firstName!
                                                                .isEmpty
                                                            ? '${getcontroller!.friendList[i].username}'
                                                            : '${getcontroller!.friendList[i].firstName} ${getcontroller!.friendList[i].lastName}',
                                                        style: TextStyle(
                                                            fontFamily: AppFonts
                                                                .segoeui,
                                                            fontSize: 13),
                                                      ),
                                                      trailing: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            child: Container(
                                                              height: 25,
                                                              width: 60,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.check,
                                                                  size: 18,
                                                                  color: !listofmap.contains(getcontroller!
                                                                          .friendList[
                                                                              i]
                                                                          .userId
                                                                          .toString())
                                                                      ? Colors
                                                                          .transparent
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: !listofmap.contains(getcontroller!
                                                                        .friendList[
                                                                            i]
                                                                        .userId
                                                                        .toString())
                                                                    ? Colors
                                                                        .transparent
                                                                    : Colors
                                                                        .green,
                                                                border: Border.all(
                                                                    color: !listofmap.contains(getcontroller!
                                                                            .friendList[
                                                                                i]
                                                                            .userId
                                                                            .toString())
                                                                        ? Colors
                                                                            .black12
                                                                        : Colors
                                                                            .green,
                                                                    width: 2),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              if (listofmap.contains(
                                                                  getcontroller!
                                                                      .friendList[
                                                                          i]
                                                                      .userId
                                                                      .toString())) {
                                                                listofmap.remove(
                                                                    getcontroller!
                                                                        .friendList[
                                                                            i]
                                                                        .userId
                                                                        .toString());
                                                                setState(() {});
                                                              } else {
                                                                listofmap.add(
                                                                    getcontroller!
                                                                        .friendList[
                                                                            i]
                                                                        .userId
                                                                        .toString()
                                                                        .trim());
                                                                setState(() {});
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                  ).then((value) {
                                    if (value is bool) {
                                      selectedOneToOneChat.clear();
                                      setState(() {});
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.redo),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Forward',
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              width: width,
                              decoration: BoxDecoration(color: Colors.white),
                              child: Obx(() => getcontroller!.block_user.value
                                  ? Center(
                                      child: Text(
                                          'You cannot reply to this conversation'),
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return Wrap(
                                                    children: [
                                                      ListTile(
                                                        leading: Icon(
                                                          Icons.image,
                                                          color: primaryColor,
                                                        ),
                                                        title: Text(
                                                          'Photo & Video',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                        onTap: () async {
                                                          FilePickerResult?
                                                              result =
                                                              await FilePicker
                                                                  .platform
                                                                  .pickFiles(
                                                            type:
                                                                FileType.media,
                                                          );
                                                          if (result!.files
                                                              .isNotEmpty) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            Get.to(SendSmsView(
                                                                    userID: widget
                                                                        .groupID,
                                                                    path:
                                                                        '${result.files[0].path}',
                                                                    extention: '${result.files[0].path}'.contains(
                                                                            '.mp4')
                                                                        ? 'video'
                                                                        : 'image',
                                                                    replyId: isActivereply
                                                                            .value
                                                                        ? replyModel
                                                                            .value
                                                                            .id
                                                                        : ''))!
                                                                .then((value) {
                                                              isActivereply
                                                                      .value =
                                                                  false;
                                                              selectedOneToOneChat
                                                                  .clear();
                                                              setState(() {});
                                                              getcontroller!.getAllMessage(
                                                                  userID: widget
                                                                      .groupID,
                                                                  fromGroup: widget
                                                                      .fromGroup);
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          Icons
                                                              .file_copy_outlined,
                                                          color: primaryColor,
                                                        ),
                                                        title: Text(
                                                          'Documents',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                        onTap: () async {
                                                          FilePickerResult?
                                                              result =
                                                              await FilePicker
                                                                  .platform
                                                                  .pickFiles(
                                                            type:
                                                                FileType.custom,
                                                            allowedExtensions: [
                                                              'pdf',
                                                              'doc'
                                                            ],
                                                          );
                                                          if (result!.files
                                                              .isNotEmpty) {
                                                            print(
                                                                'file path is = ${result.files[0].path}');
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        500),
                                                                () async {
                                                              await sentMessageAsFile(
                                                                      userID: widget
                                                                          .groupID,
                                                                      text: '',
                                                                      filePath:
                                                                          '${result.files[0].path}',
                                                                      replyid: isActivereply
                                                                              .value
                                                                          ? replyModel
                                                                              .value
                                                                              .id
                                                                          : '')
                                                                  .then(
                                                                      (value) {
                                                                isActivereply
                                                                        .value =
                                                                    false;
                                                                selectedOneToOneChat
                                                                    .clear();
                                                                setState(() {});
                                                                getcontroller!.getAllMessage(
                                                                    userID: widget
                                                                        .groupID,
                                                                    fromGroup:
                                                                        widget
                                                                            .fromGroup);
                                                              });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                            setState(() {});
                                                          }
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: primaryColor,
                                                        ),
                                                        title: Text(
                                                          'Location',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                        onTap: () {
                                                          // Get.to(MapClass())!
                                                          //     .then((value) {
                                                          //   if (value is String) {
                                                          //     print(
                                                          //         'locatoin ia = $value');
                                                          //     getcontroller!
                                                          //         .onSentMessage(
                                                          //             message:
                                                          //                 value,
                                                          //             groupId: widget
                                                          //                 .groupID);
                                                          //   }
                                                          //   Navigator.of(context)
                                                          //       .pop();
                                                          // });
                                                        },
                                                      ),
                                                      ListTile(
                                                        leading: Icon(
                                                          Icons.person_outline,
                                                          color: primaryColor,
                                                        ),
                                                        title: Text(
                                                          'Contacts',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              letterSpacing:
                                                                  0.5),
                                                        ),
                                                        onTap: () {
                                                          // Get.to(GetAllContactsPage())!
                                                          //     .then((value) {
                                                          //   if (value is String) {
                                                          //     print(
                                                          //         'Contacts ia = $value');
                                                          //     getcontroller!
                                                          //         .onSentMessage(
                                                          //             message:
                                                          //                 value,
                                                          //             groupId: widget
                                                          //                 .groupID);
                                                          //   }
                                                          //   Navigator.of(context)
                                                          //       .pop();
                                                          // });
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Icon(
                                            Icons.add,
                                            size: 35,
                                            color: primaryColor,
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 7,
                                        // ),
                                        Expanded(
                                          child: Container(
                                            constraints:
                                                BoxConstraints(minHeight: 40),
                                            width: double.infinity,
                                            child: FlutterMentions(
                                              key: key,
                                              suggestionPosition:
                                                  SuggestionPosition.Top,
                                              suggestionListHeight: 200,
                                              suggestionListDecoration:
                                                  BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                              maxLines: 5,
                                              minLines: 1,
                                              onChanged: (value) {
                                                if (!getcontroller!
                                                    .startTyping.value) {
                                                  getcontroller!
                                                      .startTyping.value = true;
                                                  getcontroller!
                                                      .userTypingStart(
                                                          groupId:
                                                              widget.groupID);
                                                }
                                                getcontroller!
                                                    .searchText.value = value;
                                              },
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      emojiShowing =
                                                      !emojiShowing;
                                                      if (emojiShowing) {
                                                        _focusNode.unfocus();
                                                      } else {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                            _focusNode);
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.tag_faces,
                                                    size: 23,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                  disabledBorder:
                                                      new OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              new BorderSide(
                                                            color:
                                                                Colors.black12,
                                                          )),
                                                  focusedBorder:
                                                      new OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              new BorderSide(
                                                            color:
                                                                Colors.black12,
                                                          )),
                                                  enabledBorder:
                                                      new OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              new BorderSide(
                                                            color:
                                                                Colors.black12,
                                                          )),
                                                  border:
                                                      new OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              new BorderSide(
                                                            color:
                                                                Colors.black12,
                                                          )),
                                                  contentPadding:
                                                      EdgeInsets.all(8),
                                                  hintText: '',
                                                  isDense: true,
                                                  hintStyle: TextStyle(
                                                      fontSize: 11,
                                                      letterSpacing: 0.5,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                              onTap: () {
                                                print('tabbbbbbbbbb');
                                                if (emojiShowing == true) {
                                                  setState(() {
                                                    emojiShowing = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    emojiShowing = false;
                                                  });
                                                }
                                              },
                                              focusNode: _focusNode,
                                              mentions: [
                                                Mention(
                                                  trigger: "@",
                                                  matchAll: true,
                                                  disableMarkup: false,
                                                  suggestionBuilder:
                                                      (Map<String, dynamic>
                                                          map) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width *
                                                                      0.050),
                                                      child: ListTile(
                                                        leading:
                                                            CircularProfileAvatar(
                                                                '',
                                                                radius: 18,
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl:
                                                                      '${map['photo']}',
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      CircularProgressIndicator(),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      Icon(Icons
                                                                          .error),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                        title: Text(
                                                            '${map['username']}'),
                                                        subtitle: Text(
                                                            '${map['display']}'),
                                                      ),
                                                    );
                                                  },
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                  data: listofUsers,
                                                )
                                              ],
                                            ),
                                            // Padding(
                                            //   padding:  EdgeInsets.only(left: 3,right: 3),
                                            //   child: TextFormField(
                                            //     controller: controller,
                                            //     onChanged: (value) {
                                            //       if (!getcontroller!
                                            //           .startTyping.value) {
                                            //         getcontroller!.startTyping.value =
                                            //             true;
                                            //         getcontroller!.userTypingStart(
                                            //             groupId: widget.groupID);
                                            //       }
                                            //       getcontroller!.searchText.value =
                                            //           value;
                                            //     },
                                            //     //keyboardType: TextInputType.multiline,
                                            //     maxLines: null,
                                            //     minLines: 1,
                                            //     //focusNode: FocusNode(canRequestFocus: true),
                                            //     style: TextStyle(
                                            //         color: Colors.black,
                                            //         fontSize: 14),
                                            //     decoration: InputDecoration(
                                            //         disabledBorder:
                                            //             new OutlineInputBorder(
                                            //                 borderRadius:
                                            //                     BorderRadius.circular(
                                            //                         30),
                                            //                 borderSide:
                                            //                     new BorderSide(
                                            //                   color: Colors.black12,
                                            //                 )),
                                            //         focusedBorder:
                                            //             new OutlineInputBorder(
                                            //                 borderRadius:
                                            //                     BorderRadius.circular(
                                            //                         30),
                                            //                 borderSide:
                                            //                     new BorderSide(
                                            //                   color: Colors.black12,
                                            //                 )),
                                            //         enabledBorder:
                                            //             new OutlineInputBorder(
                                            //                 borderRadius:
                                            //                     BorderRadius.circular(
                                            //                         30),
                                            //                 borderSide:
                                            //                     new BorderSide(
                                            //                   color: Colors.black12,
                                            //                 )),
                                            //         border: new OutlineInputBorder(
                                            //             borderRadius:
                                            //                 BorderRadius.circular(30),
                                            //             borderSide: new BorderSide(
                                            //               color: Colors.black12,
                                            //             )),
                                            //         contentPadding:
                                            //             EdgeInsets.all(8),
                                            //         hintText: '',
                                            //         isDense: true,
                                            //         hintStyle: TextStyle(
                                            //             fontSize: 11,
                                            //             letterSpacing: 0.5,
                                            //             color: Colors.black,
                                            //             fontWeight: FontWeight.w400)),
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Visibility(
                                          visible: getcontroller!
                                                  .searchText.value.isEmpty
                                              ? true
                                              : false,
                                          child: InkWell(
                                            onTap: () async {
                                              final ImagePicker _picker =
                                                  ImagePicker();
                                              var pickedFile =
                                                  await _picker.getImage(
                                                source: ImageSource.camera,
                                              );
                                              print(
                                                  'file path is = ${pickedFile!.path}');
                                              Get.to(SendSmsView(
                                                userID: widget.groupID,
                                                extention: 'image',
                                                path: '${pickedFile.path}',
                                              ))!
                                                  .then((value) {
                                                getcontroller!.getAllMessage(
                                                    userID: widget.groupID,
                                                    fromGroup:
                                                        widget.fromGroup);
                                              });
                                            },
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              color: primaryColor,
                                              size: 35,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Obx(
                                          () => getcontroller!
                                                  .searchText.value.isEmpty
                                              ? RecordButton(
                                                  controller: animcontroller,
                                                  RecordStart: () async {
                                                    audio_path = '';
                                                    bool result =
                                                        await record.Record()
                                                            .hasPermission();
                                                    String path =
                                                        await getFilePath();
                                                    audio_path = path;
                                                    if (result) {
                                                      RecordMp3.instance.start(
                                                          path, (type) {});
                                                      getcontroller!
                                                          .recording_start
                                                          .value = true;
                                                    } else {
                                                      print('access deny');
                                                    }
                                                    setState(() {});
                                                  },
                                                  recordStop: () async {
                                                    RecordMp3.instance.stop();
                                                    getcontroller!
                                                        .recording_start
                                                        .value = false;
                                                    Future.delayed(
                                                        Duration(
                                                            milliseconds: 500),
                                                        () async {
                                                      print(
                                                          'audio path is =${audio_path}');
                                                      await sentMessageAsFile(
                                                              replyid: isActivereply
                                                                          .value ==
                                                                      true
                                                                  ? replyModel
                                                                      .value.id
                                                                  : '',
                                                              userID: widget
                                                                  .groupID,
                                                              text: '',
                                                              filePath:
                                                                  '$audio_path')
                                                          .then((value) {
                                                        File(audio_path)
                                                            .delete();
                                                        getcontroller!
                                                            .getAllMessage(
                                                                userID: widget
                                                                    .groupID,
                                                                fromGroup: widget
                                                                    .fromGroup);
                                                      });
                                                    });
                                                    setState(() {});
                                                  },
                                                )
                                              : InkWell(
                                                  onTap: () {
                                                    if (isActivereply.value) {
                                                      getcontroller!
                                                          .onSentMessage(
                                                              message: key
                                                                  .currentState!
                                                                  .controller!
                                                                  .text,
                                                              to_userId: widget
                                                                  .groupID,
                                                              fromGroup: widget
                                                                  .fromGroup,
                                                              replyID: replyModel
                                                                  .value.id
                                                                  .toString());
                                                      replyModel.value =
                                                          Messages();
                                                      isActivereply.value =
                                                          false;
                                                      key.currentState!
                                                          .controller!
                                                          .clear();
                                                      controller.clear();
                                                      getcontroller!.searchText
                                                          .value = '';
                                                      setState(() {});
                                                    } else {
                                                      if (key.currentState!
                                                          .controller!.text
                                                          .trim()
                                                          .isNotEmpty) {
                                                        getcontroller!
                                                            .onSentMessage(
                                                                message: key
                                                                    .currentState!
                                                                    .controller!
                                                                    .text,
                                                                to_userId:
                                                                    widget
                                                                        .groupID,
                                                                fromGroup: widget
                                                                    .fromGroup);
                                                        key.currentState!
                                                            .controller!
                                                            .clear();
                                                        controller.clear();
                                                        getcontroller!
                                                            .searchText
                                                            .value = '';
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    height: height / 18,
                                                    width: width / 10,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.send_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: primaryColor),
                                                  ),
                                                ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                      ],
                                    )),
                            ),
                            Offstage(
                              key: _textFieldKey,
                              offstage: !emojiShowing,
                              child: SizedBox(
                                height: 250,
                                child: EmojiPicker(
                                    onEmojiSelected:
                                        (Category category, Emoji emoji) {
                                      _onEmojiSelected(emoji);
                                    },
                                    onBackspacePressed: _onBackspacePressed,
                                    config: Config(
                                        columns: 7,
                                        // Issue: https://github.com/flutter/flutter/issues/28894
                                        emojiSizeMax:
                                            32 * (Platform.isIOS ? 1.30 : 1.0),
                                        verticalSpacing: 0,
                                        horizontalSpacing: 0,
                                        initCategory: Category.SMILEYS,
                                        bgColor: Colors.white,
                                        indicatorColor: Colors.blue,
                                        iconColor: Colors.grey,
                                        iconColorSelected: Colors.blue,
                                        progressIndicatorColor: Colors.blue,
                                        backspaceColor: Colors.blue,
                                        skinToneDialogBgColor: Colors.white,
                                        skinToneIndicatorColor: Colors.grey,
                                        enableSkinTones: true,
                                        showRecentsTab: true,
                                        recentsLimit: 28,
                                        // noRecentsText: 'No Recents',
                                        // noRecentsStyle: const TextStyle(
                                        //     fontSize: 20, color: Colors.black26),
                                        tabIndicatorAnimDuration:
                                            kTabScrollDuration,
                                        categoryIcons: const CategoryIcons(),
                                        buttonMode: ButtonMode.MATERIAL)),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: 5,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getFilePath() async {
    String key = Uuid().v4();
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${key}.mp3";
  }
}

class SmsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Color(0xffF3F3F3)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(size.width, size.height * 0.0300000);
    path_0.lineTo(0, size.height * 0.5014000);
    path_0.lineTo(size.width, size.height * 0.9393000);
    path_0.lineTo(size.width, size.height * 0.0300000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class SmsPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, size.height);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width, size.height * 0.5019000);
    path_0.lineTo(0, size.height);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

Color returnColorFromString(String value) {
  return Color.fromARGB(
      int.parse(value.split(',')[0]),
      int.parse(value.split(',')[1]),
      int.parse(value.split(',')[2]),
      int.parse(value.split(',')[3]));
}
