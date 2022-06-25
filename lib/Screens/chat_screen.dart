import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/BaseURL.dart';
import 'package:rooya/GlobalWidget/Photo_View_Class.dart';
import 'package:rooya/Plugins/FocusedMenu/focused_menu.dart';
import 'package:rooya/Plugins/FocusedMenu/modals.dart';
import 'package:rooya/Providers/ChatScreenProvider.dart';
import 'package:rooya/Providers/ClickController/SelectIndexController.dart';
import 'package:rooya/Providers/OneToOneModel.dart';
import 'package:rooya/Utils/StoryViewPage.dart';
import 'package:rooya/Utils/UserDataService.dart';
import 'package:rooya/Utils/primary_color.dart';
import 'package:rooya/Utils/text_filed/app_font.dart';
import '../GlobalWidget/ConfirmationDialog.dart';
import '../GlobalWidget/FileUploader.dart';
import '../Models/OneTwoOneOuterModel.dart';
import 'SearchUser/NewUserSearchPage.dart';
import 'UserChat/UserChat.dart';

StreamController<double> sendSmsStreamcontroller =
    StreamController<double>.broadcast();

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
  final controller = Get.put(ChatScreenProvider());

  var selectedIndexController = Get.find<SelectIndexController>();
  StreamSubscription<double>? streamSubscription;
  @override
  void initState() {
    var data = storage.hasData('chat_list');
    if (data) {
      controller.listofChat.value =
          OneToOneChatOuterModel.fromJson(jsonDecode(storage.read('chat_list')))
              .data!;
    }
    controller.getChatList().then((value) async {
      await getStoryData();
      if(mounted){
        setState(() {});
      }
    });
    controller.connectToSocket();
    if (!streamController.hasListener) {
      streamController.stream.listen((event) {
        setState(() {});
      });
    }
    streamSubscription = sendSmsStreamcontroller.stream.listen((event) {
      setState(() {});
    });
    super.initState();
  }

  Future getStoryData() async {
    await controller.getStoryList();
  }

  var listOfSelectedMember = <Data>[].obs;

  @override
  void dispose() {
    controller.leaveGroup();
    streamSubscription!.cancel();
    super.dispose();
  }

  var selectedOneToOneChat = <OneToOneChatModel>[].obs;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Divider(),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: listOfSelectedMember.isNotEmpty
                    ? Container(
                        decoration:
                            BoxDecoration(color: primaryColor.withOpacity(0.5)),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  listOfSelectedMember.clear();
                                  setState(() {});
                                },
                                icon: Icon(Icons.clear)),
                            Text('${listOfSelectedMember.length}'),
                            Expanded(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.volume_off,
                                    size: 20,
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
                                              i < listOfSelectedMember.length;
                                              i++) {
                                            Map payLoad = {
                                              'server_key': serverKey,
                                              'userId': listOfSelectedMember[i]
                                                  .userId
                                                  .toString()
                                            };
                                            ApiUtils.deleteConversation(
                                                map: payLoad);
                                            controller.listofChat.remove(
                                                listOfSelectedMember[i]);
                                          }
                                          listOfSelectedMember.clear();
                                          setState(() {});
                                          Navigator.of(context).pop();
                                        });
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    CupertinoIcons.delete,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.more_vert,
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
                    : ListTile(
                        title: InkWell(
                          onTap: () {
                            return createAlertDialoge(context);
                          },
                          child: Text(
                            '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: AppFonts.segoeui),
                          ),
                        ),
                        trailing: FocusedMenuHolder(
                          blurSize: 5.0,
                          menuItemExtent: 45,
                          menuWidth: width * 0.4,
                          menuOffset: 0,
                          openWithTap: true,
                          blurBackgroundColor: Colors.black54,
                          onCneTapMenuItems: <FocusedMenuItem>[
                            FocusedMenuItem(
                                title: Text("Select All"), onPressed: () {}),
                            FocusedMenuItem(
                                title: Text("Delete All"), onPressed: () {}),
                            FocusedMenuItem(
                                title: Text("Mark All"), onPressed: () {}),
                          ],
                          onPressed: () {},
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
              ),
              Obx(
                () => !controller.loadChat.value &&
                        controller.listofChat.isEmpty
                    ? SliverToBoxAdapter(
                        child: SizedBox(
                        child: Center(
                            // child: SpinKitFadingCircle(
                            //   color: buttonColor,
                            //   size: 50.0,
                            // ),
                            ),
                        height: height - 150,
                        width: width,
                      ))
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                        var date = DateTime.fromMillisecondsSinceEpoch(int.parse(
                                "${controller.listofChat[index].lastMessage!.time}") *
                            1000);
                        return Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            dragDismissible: false,
                            dismissible: DismissiblePane(onDismissed: () {}),
                            children: [
                              SlidableAction(
                                onPressed: (c) async {
                                  await showAlertDialog(
                                      context: context,
                                      cancel: () {
                                        Navigator.of(context).pop();
                                      },
                                      done: () {
                                        Map map = {
                                          'server_key': serverKey,
                                          'user_id':
                                              '${controller.listofChat[index].userId}'
                                        };
                                        ApiUtils.deleteConversation(map: map)
                                            .then((value) {
                                          controller.getChatList();
                                        });
                                        controller.listofChat.removeAt(index);
                                        Navigator.of(context).pop();
                                      });
                                  setState(() {});
                                },
                                autoClose: true,
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                              SlidableAction(
                                onPressed: doNothing,
                                backgroundColor: Color(0xFF21B7CA),
                                foregroundColor: Colors.white,
                                icon: Icons.share,
                                label: 'Share',
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) async {
                                  // if (controller.listofMember[index].block == 0) {
                                  //   Map map = {
                                  //     'userId':
                                  //         '${controller.listofMember[index].members![controller.listofMember[index].members!.indexWhere((element) => element.userId.toString() != storage.read('userID'))]}',
                                  //     'groupId':
                                  //         '${controller.listofMember[index].groupId}'
                                  //   };
                                  //   await ApiUtils.blockUser(map: map);
                                  //   await controller.getGroupList();
                                  //   setState(() {});
                                  // } else {
                                  //   Map map = {
                                  //     'userId':
                                  //         '${controller.listofMember[index].members![controller.listofMember[index].members!.indexWhere((element) => element.userId.toString() != storage.read('userID'))]}',
                                  //     'groupId':
                                  //         '${controller.listofMember[index].groupId}'
                                  //   };
                                  //   await ApiUtils.unblockUser(map: map);
                                  //   await controller.getGroupList();
                                  //   setState(() {});
                                  // }
                                },
                                backgroundColor: Color(0xFF7BC043),
                                foregroundColor: Colors.white,
                                icon: Icons.block,
                                // label: controller.listofMember[index].block == 0
                                //     ? 'Block'
                                //     : 'Unblock',
                              ),
                              SlidableAction(
                                onPressed: doNothing,
                                backgroundColor: Color(0xFF0392CF),
                                foregroundColor: Colors.white,
                                icon: Icons.save,
                                label: 'Save',
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (listOfSelectedMember.isEmpty) {
                                    controller.leaveGroup();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => UserChat(
                                                  groupID: controller
                                                      .listofChat[index].userId
                                                      .toString(),
                                                  blocked: false,
                                                  name: controller
                                                          .listofChat[index]
                                                          .firstName
                                                          .toString()
                                                          .isEmpty
                                                      ? controller
                                                          .listofChat[index]
                                                          .username
                                                          .toString()
                                                      : controller
                                                              .listofChat[index]
                                                              .firstName
                                                              .toString() +
                                                          controller
                                                              .listofChat[index]
                                                              .lastName
                                                              .toString(),
                                                  profilePic: controller
                                                      .listofChat[index].avatar,
                                                  fromGroup: false,
                                                ))).then((value) async {
                                      await controller.getChatList();
                                      controller.connectToSocket();
                                      setState(() {});
                                    });
                                  } else {
                                    if (!listOfSelectedMember.contains(
                                        controller.listofChat[index])) {
                                      listOfSelectedMember
                                          .add(controller.listofChat[index]);
                                    } else {
                                      listOfSelectedMember
                                          .remove(controller.listofChat[index]);
                                    }
                                    setState(() {});
                                  }
                                },
                                onLongPress: () {
                                  if (!listOfSelectedMember
                                      .contains(controller.listofChat[index])) {
                                    listOfSelectedMember
                                        .add(controller.listofChat[index]);
                                  } else {
                                    listOfSelectedMember
                                        .remove(controller.listofChat[index]);
                                  }
                                  setState(() {});
                                },
                                child: Row(
                                  children: [
                                    listOfSelectedMember.isNotEmpty
                                        ? !listOfSelectedMember.contains(
                                                controller.listofChat[index])
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        width: 1,
                                                        color: buttonColor)),
                                              )
                                            : Container(
                                                height: 20,
                                                width: 20,
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: buttonColor,
                                                ),
                                              )
                                        : SizedBox(),
                                    Expanded(
                                      child: ListTile(
                                        leading: controller.idsOfUserStories
                                                .contains(
                                                    '${controller.listofChat[index].userId}')
                                            ? CircularProfileAvatar(
                                                '',
                                                radius: 28,
                                                borderWidth: 2,
                                                borderColor: buttonColor,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${controller.listofChat[index].avatar!}",
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                                onTap:
                                                    listOfSelectedMember
                                                            .isNotEmpty
                                                        ? null
                                                        : () {
                                                            if (listOfSelectedMember
                                                                .isEmpty) {
                                                              int i = controller
                                                                  .idsOfUserStories
                                                                  .indexWhere((element) =>
                                                                      element ==
                                                                      '${controller.listofChat[index].userId}');
                                                              context.pushTransparentRoute(
                                                                  StoryViewPage(
                                                                userStories:
                                                                    controller
                                                                        .storyList[i],
                                                                socket:
                                                                    controller
                                                                        .socket,
                                                              )).then((value) async{
                                                                await controller.getChatList();
                                                                controller.connectToSocket();
                                                                setState(() {});
                                                              });
                                                            }
                                                          },
                                                imageFit: BoxFit.cover,
                                              )
                                            : CircularProfileAvatar(
                                                '',
                                                radius: 28,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${controller.listofChat[index].avatar!}",
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                                onTap: listOfSelectedMember
                                                        .isNotEmpty
                                                    ? null
                                                    : () {
                                                        if (listOfSelectedMember
                                                            .isEmpty) {
                                                          Get.to(
                                                              Photo_View_Class(
                                                            url:
                                                                "${controller.listofChat[index].avatar!}",
                                                          ));
                                                        }
                                                      },
                                                imageFit: BoxFit.cover,
                                              ),
                                        title: Text(
                                          "${controller.listofChat[index].name!}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontFamily: AppFonts.segoeui,
                                              fontSize: 16),
                                        ),
                                        subtitle: Text(
                                          controller.listofChat[index]
                                                      .lastMessage!.type ==
                                                  'text'
                                              ? "${controller.listofChat[index].lastMessage!.text}"
                                              : '${controller.listofChat[index].lastMessage!.type}',
                                          style: TextStyle(
                                              color: Color(0XFF373737),
                                              fontFamily: AppFonts.segoeui,
                                              fontSize: 12),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        trailing: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            "${controller.listofChat[index].messageCount}" ==
                                                    '0'
                                                ? SizedBox()
                                                : Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green),
                                                    child: Text(
                                                      "${controller.listofChat[index].messageCount}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontFamily:
                                                              AppFonts.segoeui),
                                                    ),
                                                    padding: EdgeInsets.all(5),
                                                  ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              //'${timeago.format(DateTime.parse("${controller.listofMember[index].lastActive}"), locale: 'en_short')} ago',
                                              //"${controller.listofChat.value.data![index].lastMessage!.timeText}",
                                              '${dateFormat.format(date)}',
                                              style: TextStyle(
                                                  color: Color(0XFF373737),
                                                  fontSize: 10,
                                                  fontFamily: AppFonts.segoeui),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                color: Colors.black12,
                                margin: EdgeInsets.only(
                                    left: width * 0.23,
                                    right: width * 0.040,
                                    bottom: height * 0.018),
                              ),
                            ],
                          ),
                        );
                      }, childCount: controller.listofChat.length)),
              )
            ],
          ),
          Obx(() => controller.isLoading.value == true
              ? InkWell(
                  onTap: () {
                    controller.isLoading.value = false;
                  },
                  child: Container(
                    height: height,
                    width: width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  ),
                )
              : SizedBox())
        ],
      ),
      // floatingActionButton: CustomButton(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onLongPress: () async {
              final ImagePicker _picker = ImagePicker();
              var pickedFile = await _picker.getVideo(
                source: ImageSource.camera,
              );
              print('file path is = ${pickedFile!.path}');
              var listofmap = [];
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, setState) {
                  return Container(
                    height: height - 100,
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              InkWell(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontFamily: AppFonts.segoeui),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              listofmap.isNotEmpty
                                  ? InkWell(
                                      child: Text(
                                        'Forward',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.blue,
                                            fontFamily: AppFonts.segoeui),
                                      ),
                                      onTap: () async {
                                        if (pickedFile != null) {
                                          for (var i in listofmap) {
                                            await sentMessageAsFile(
                                                userID: i,
                                                text: '',
                                                filePath: '${pickedFile.path}');
                                          }
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    )
                                  : SizedBox()
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.friendList.length,
                            itemBuilder: (context, i) => Column(
                              children: [
                                ListTile(
                                  leading: CircularProfileAvatar(
                                    '',
                                    radius: 23,
                                    child: Image.network(
                                      '${controller.friendList[i].avatar}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    controller.friendList[i].firstName!.isEmpty
                                        ? controller.friendList[i].username
                                            .toString()
                                        : '${controller.friendList[i].firstName} ${controller.friendList[i].lastName}',
                                    style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 13),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          height: 25,
                                          width: 60,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              size: 18,
                                              color: !listofmap.contains(
                                                      controller
                                                          .friendList[i].userId
                                                          .toString())
                                                  ? Colors.transparent
                                                  : Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: !listofmap.contains(
                                                    controller
                                                        .friendList[i].userId
                                                        .toString())
                                                ? Colors.transparent
                                                : Colors.green,
                                            border: Border.all(
                                                color: !listofmap.contains(
                                                        controller.friendList[i]
                                                            .userId
                                                            .toString())
                                                    ? Colors.black12
                                                    : Colors.green,
                                                width: 2),
                                          ),
                                        ),
                                        onTap: () {
                                          if (listofmap.contains(controller
                                              .friendList[i].userId
                                              .toString())) {
                                            listofmap.remove(controller
                                                .friendList[i].userId
                                                .toString());
                                            setState(() {});
                                          } else {
                                            listofmap.add(controller
                                                .friendList[i].userId
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
              ).then((value) async {
                if (value is bool) {
                  selectedOneToOneChat.clear();
                  await controller.getChatList();
                  setState(() {});
                }
              });
            },
            onTap: () async {
              final ImagePicker _picker = ImagePicker();
              var pickedFile = await _picker.getImage(
                source: ImageSource.camera,
              );
              print('file path is = ${pickedFile!.path}');
              var listofmap = [];
              await controller.getFriendList();
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) =>
                    StatefulBuilder(builder: (context, setState) {
                  return Container(
                    height: height - 100,
                    width: width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              InkWell(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.blue,
                                      fontFamily: AppFonts.segoeui),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              listofmap.isNotEmpty
                                  ? InkWell(
                                      child: Text(
                                        'Forward',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.blue,
                                            fontFamily: AppFonts.segoeui),
                                      ),
                                      onTap: () async {
                                        if (pickedFile != null) {
                                          for (var i in listofmap) {
                                            await sentMessageAsFile(
                                                userID: i,
                                                text: '',
                                                filePath: '${pickedFile.path}').then((value) => controller.getChatList());
                                          }
                                          Navigator.of(context).pop();
                                        }
                                      },
                                    )
                                  : SizedBox()
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.friendList.length,
                            itemBuilder: (context, i) => Column(
                              children: [
                                ListTile(
                                  leading: CircularProfileAvatar(
                                    '${controller.friendList[i].avatar}',
                                    radius: 23,
                                    imageFit: BoxFit.cover,
                                  ),
                                  title: Text(
                                    controller.friendList[i].firstName!.isEmpty
                                        ? controller.friendList[i].username
                                            .toString()
                                        : '${controller.friendList[i].firstName} ${controller.friendList[i].lastName}',
                                    style: TextStyle(
                                        fontFamily: AppFonts.segoeui,
                                        fontSize: 13),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          height: 25,
                                          width: 60,
                                          child: Center(
                                            child: Icon(
                                              Icons.check,
                                              size: 18,
                                              color: !listofmap.contains(
                                                      controller
                                                          .friendList[i].userId
                                                          .toString())
                                                  ? Colors.transparent
                                                  : Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: !listofmap.contains(
                                                    controller
                                                        .friendList[i].userId
                                                        .toString())
                                                ? Colors.transparent
                                                : Colors.green,
                                            border: Border.all(
                                                color: !listofmap.contains(
                                                        controller.friendList[i]
                                                            .userId
                                                            .toString())
                                                    ? Colors.black12
                                                    : Colors.green,
                                                width: 2),
                                          ),
                                        ),
                                        onTap: () {
                                          if (listofmap.contains(controller
                                              .friendList[i].userId
                                              .toString())) {
                                            listofmap.remove(controller
                                                .friendList[i].userId
                                                .toString());
                                            setState(() {});
                                          } else {
                                            listofmap.add(controller
                                                .friendList[i].userId
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
              ).then((value) async {
                if (value is bool) {
                  selectedOneToOneChat.clear();
                  await controller.getChatList();
                  setState(() {});
                }
              });
            },
            child: Container(
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Color(0xFF0BAB0D), shape: BoxShape.circle),
            ),
          ),
          SizedBox(
            width: width/3.7,
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Get.to(NewUserSearchpage(
                listofFriend: controller.friendList,
              ))!
                  .then((value) async {
                controller.leaveGroup();
                Future.delayed(Duration(milliseconds: 500), () async {
                  await controller.getChatList();
                  controller.connectToSocket();
                });
                setState(() {});
              });
            },
            child: SvgPicture.asset(
              'assets/user/prs.svg',
              color: Colors.white,
            ),
            backgroundColor: Color(0xFF0BAB0D),
          ),
        ],
      ),
    );
  }

  String typeReturn(String value) {
    if (value.contains('Contacts#=-:')) {
      return 'Contact';
    } else if (value.contains('.jpg') ||
        value.contains('.png') ||
        value.contains('.jpeg')) {
      return 'Image';
    } else if (value.contains('.mp4')) {
      return 'Video';
    } else if (value.contains('.mp3') ||
        value.contains('.aac') ||
        value.contains('.ac3') ||
        value.contains('.h264') ||
        value.contains('.wav') ||
        value.contains('.csv') ||
        value.contains('.wma') ||
        value.contains('.wmv')) {
      return 'Audio';
    } else if (value.contains('.pdf')) {
      return 'Documents';
    } else {
      return value;
    }
  }

  doNothing(BuildContext context) {}

  createAlertDialoge(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            insetPadding: EdgeInsets.only(left: 15, right: 15),
            // contentPadding: EdgeInsets.zero,
            // clipBehavior: Clip.antiAliasWithSaveLayer,
            content: Container(
              height: 260,
              width: 350,
              // color: Colors.green,
              child: Column(
                children: [
                  Text(
                    'Edit your Status',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      fontFamily: AppFonts.segoeui,
                      color: Color(0XFF0BAB0D),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Status',
                        style: TextStyle(
                            fontSize: 12, fontFamily: AppFonts.segoeui),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 80,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0XFFF5F5F5),
                            borderRadius: BorderRadius.circular(8)),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'I Love Rooya',
                              hintStyle: TextStyle(
                                  fontSize: 13, fontFamily: AppFonts.segoeui),
                              contentPadding: EdgeInsets.only(left: 8)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    child: Center(
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: AppFonts.segoeui),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0XFF0BAB0D),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 40,
                    width: 130,
                    child: Center(
                      child: Text(
                        'NO THANKS',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontFamily: AppFonts.segoeui),
                      ),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0XFFCCCCCC),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CircularProfileAvatar extends StatefulWidget {
  CircularProfileAvatar(this.imageUrl,
      {this.initialsText = const Text(''),
      this.cacheImage = true,
      this.radius = 50.0,
      this.borderWidth = 0.0,
      this.borderColor = Colors.white,
      this.backgroundColor = Colors.white,
      this.elevation = 0.0,
      this.showInitialTextAbovePicture = false,
      this.onTap,
      this.foregroundColor = Colors.transparent,
      this.placeHolder,
      this.errorWidget,
      this.imageBuilder,
      this.animateFromOldImageOnUrlChange,
      this.progressIndicatorBuilder,
      this.child,
      this.imageFit = BoxFit.cover});

  /// sets radius of the avatar circle, [borderWidth] is also included in this radius.
  /// default value is 0.0
  final double radius;

  /// sets shadow of the circle,
  /// default value is 0.0
  final double elevation;

  /// sets the borderWidth of the circile,
  /// default value is 0.0
  final double borderWidth;

  /// The color with which to fill the border of the circle.
  /// default value [Colors.white]
  final Color borderColor;

  /// The color with which to fill the circle.
  /// default value [Colors.white]
  final Color backgroundColor;

  /// sets the [foregroundColor] of the circle, It only works if [showInitialTextAbovePicture] is set to true.
  /// [foregroundColor] doesn't include border of the circle.
  final Color foregroundColor;

  /// it takes a URL of the profile image.
  final String imageUrl;

  /// Sets the initials of user's name.
  final Text initialsText;

  /// Displays initials above profile picture if set to true, You can set [foregroundColor] value as well if [showInitialTextAbovePicture]
  /// is set to true.
  final bool showInitialTextAbovePicture;

  /// Cache the image against [imageUrl] in app memory if set true. it is true by default.
  final bool cacheImage;

  /// sets onTap gesture.
  final GestureTapCallback? onTap;

  /// Widget displayed while the target [imageUrl] is loading, works only if [cacheImage] is true.
  final PlaceholderWidgetBuilder? placeHolder;

  /// Widget displayed while the target [imageUrl] failed loading, works only if [cacheImage] is true.
  final LoadingErrorWidgetBuilder? errorWidget;

  /// Widget displayed while the target [imageUrl] is loading, works only if [cacheImage] is true.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Optional builder to further customize the display of the image.
  final ImageWidgetBuilder? imageBuilder;

  /// When set to true it will animate from the old image to the new image
  /// if the url changes.
  final bool? animateFromOldImageOnUrlChange;

  /// Setting child will hide every other widget [initialsText] and profile picture against [imageUrl].
  /// Best use case is passing [AssetImage] as profile picture. You can pass [imageUrl] as empty string if you want to set child value.
  final Widget? child;

  /// How to inscribe the image into the space allocated during layout.
  /// Set the [BoxFit] value as you want.
  final BoxFit imageFit;

  @override
  _CircularProfileAvatarState createState() => _CircularProfileAvatarState();
}

class _CircularProfileAvatarState extends State<CircularProfileAvatar> {
  Widget? _initialsText;

  @override
  Widget build(BuildContext context) {
    _initialsText = Center(child: widget.initialsText);
    return GestureDetector(
      onTap: widget.onTap,
      child: Material(
        type: MaterialType.circle,
        elevation: widget.elevation,
        color: widget.borderColor,
        child: Container(
            height: widget.radius * 2,
            width: widget.radius * 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.radius),
              border: Border.all(
                  width: widget.borderWidth, color: widget.borderColor),
            ),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.radius)),
                child: widget.child == null
                    ? Stack(
                        fit: StackFit.expand,
                        children: widget.imageUrl.isEmpty
                            ? <Widget>[_initialsText!]
                            : widget.showInitialTextAbovePicture
                                ? <Widget>[
                                    profileImage(),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: widget.foregroundColor,
                                        borderRadius: BorderRadius.circular(
                                            widget.radius),
                                      ),
                                    ),
                                    _initialsText!,
                                  ]
                                : <Widget>[
                                    _initialsText!,
                                    profileImage(),
                                  ],
                      )
                    : child(),
              ),
            )),
      ),
    );
  }

  Widget child() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: Container(
        height: widget.radius * 2,
        width: widget.radius * 2,
        child: widget.child,
      ),
    );
  }

  Widget profileImage() {
    return widget.cacheImage
        ? ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: CachedNetworkImage(
              fit: widget.imageFit,
              imageUrl: widget.imageUrl,
              errorWidget: widget.errorWidget,
              placeholder: widget.placeHolder,
              imageBuilder: widget.imageBuilder,
              progressIndicatorBuilder: widget.progressIndicatorBuilder,
              useOldImageOnUrlChange:
                  widget.animateFromOldImageOnUrlChange ?? false,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius),
            child: Image.network(
              widget.imageUrl,
              fit: widget.imageFit,
            ));
  }
}
