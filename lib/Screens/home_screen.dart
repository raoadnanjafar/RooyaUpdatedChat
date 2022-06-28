import 'dart:convert';
import 'dart:io';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/Models/UserDataModel.dart';
import 'package:rooya/Providers/ClickController/SelectIndexController.dart';
import 'package:rooya/Screens/rooms_screen.dart';
import 'package:rooya/Screens/sliver_class/sliver.dart';
import 'package:rooya/Utils/UserDataService.dart';
import 'package:rooya/Utils/primary_color.dart';
import 'package:get/get.dart';

import '../ApiConfig/ApiUtils.dart';
import '../Block_users/Block_Usera_Screen.dart';
import '../GlobalWidget/Photo_View_Class.dart';
import '../Providers/ChatScreenProvider.dart';
import '../Utils/StoryViewPage.dart';
import 'Information/UserChatInformation/user_chat_information.dart';
import 'Settings/Appearance/Apearence.dart';
import 'Settings/Settings.dart';
import 'chat_screen.dart';
import 'group_screen.dart';
import 'login_screens/sign_in_tabs_handle.dart';

final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var selectController = Get.put(SelectIndexController());

  List iconList = [
    'assets/user/prs.svg',
    //'assets/user/single.svg',
    'assets/user/persons.svg',
    'assets/user/sw.svg',
    // 'assets/user/fvrt.svg',
  ];
  List textList = [
    'Chat',
    'Groups',
    'Rooms',
  ];

  int currentIndex = 0;
  final controller = Get.put(ChatScreenProvider());

  List tabContent = [
    (ChatScreen()),
    //(FriendsScreen()),
    (GroupScreen()),
    (RoomsScreen()),
    // (FriendsScreen()),
  ];

  @override
  void initState() {
    GetStorage storage = GetStorage();
    UserDataService.userDataModel =
        UserDataModel.fromJson(jsonDecode(storage.read('userData')));
    selectController.observeronSearch();
    header = {
      'Authorization': 'Basic YWRtaW46MTIzNA==',
      'x-auth-token': '${storage.read('token')}',
    };
    token = '?access_token=${storage.read('token')}';
    super.initState();
  }

  bool indexColors = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
          child: Scaffold(
              key: scaffoldStateKey,
              drawer: Drawer(
                  width: 220,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => hasUserStory.value
                              ? CircularProfileAvatar(
                                  '${UserDataService.userDataModel!.userData!.avatar}',
                                  radius: 46,
                                  borderWidth: 2,
                                  borderColor: buttonColor,
                                  backgroundColor: Colors.blueGrey[100]!,
                                  onTap: () {
                                    int i = storyIds.indexWhere((element) =>
                                        element ==
                                        '${UserDataService.userDataModel!.userData!.userId.toString()}');
                                    context.pushTransparentRoute(StoryViewPage(
                                      userStories: allstoryList[i],
                                      isAdmin: true,
                                    )).then((value)async{
                                      await controller.getStoryList();
                                      setState(() {
                                        
                                      });
                                    });
                                  },
                                )
                              : CircularProfileAvatar(
                                  '${UserDataService.userDataModel!.userData!.avatar}',
                                  radius: 46,
                                  backgroundColor: Colors.blueGrey[100]!,
                                  onTap: () {
                                    Get.to(Photo_View_Class(
                                      url:
                                          "${UserDataService.userDataModel!.userData!.avatar}",
                                    ));
                                  },
                                ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(UserChatInformation(
                                userID:
                                    '${UserDataService.userDataModel!.userData!.userId}'));
                          },
                          child: Text(
                            '${UserDataService.userDataModel!.userData!.firstName}  ${UserDataService.userDataModel!.userData!.lastName}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        InkWell(
                            onTap: () {
                              Get.to(UserChatInformation(
                                  userID:
                                      '${UserDataService.userDataModel!.userData!.userId}'));
                            },
                            child: Text(
                              '${UserDataService.userDataModel!.userData!.username}@',
                              style: TextStyle(fontSize: 20),
                            )),
                        Divider(
                          height: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(Apearennce());
                          },
                          child: Text(
                            'Appearance',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        InkWell(
                          onTap: () async {
                            Get.to(BlockUsersScreenList())?.then((value) async {
                              await controller.getChatList();
                              await controller.getFriendList();
                              setState(() {});
                            });
                          },
                          child: Text(
                            'Blocked Users',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(Settings());
                          },
                          child: Text(
                            'Settings',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        InkWell(
                          onTap: () {
                            var selectController =
                                Get.find<SelectIndexController>();
                            // final controller = Get.find<GroupProvider>();
                            selectController.updateColor(0);
                            // controller.listofMember.value=[];
                            storage.erase();
                            Get.deleteAll();
                            Get.offAll(SignInTabsHandle());
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )),
              backgroundColor: Colors.white,
              body: DefaultTabController(
                  length: 3,
                  child: NestedScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    headerSliverBuilder: (context, isScrool) {
                      return [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0.5,
                          collapsedHeight: Platform.isAndroid
                              ? height * 0.160
                              : height * 0.180,
                          backgroundColor: Colors.white,
                          expandedHeight: height * 0.120,
                          forceElevated: true, //* here
                          shadowColor: Colors.black.withOpacity(0.5),
                          bottom: TabBar(
                            onTap: (w) {
                              setState(() {
                                //indexColors = false;
                              });
                            },
                            indicatorColor: Colors.green,
                            //indicatorWeight: 2,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: [
                              Tab(
                                height: 39,
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/user/prs.svg',
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Chat',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Tab(
                                height: 40,
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/user/persons.svg',
                                    ),
                                    Text(
                                      'Groups',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Tab(
                                height: 40,
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/user/sw.svg',
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'Rooms',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          flexibleSpace: MySliver(),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        (ChatScreen()),
                        (GroupScreen()),
                        (RoomsScreen()),
                      ],
                    ),
                  )))),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.widget);

  final Widget widget;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
// MyDelegate(Container(
// height: 100,
// color: Colors.white,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: iconList.map((e) {
// int index = iconList.indexOf(e);
// return Obx(
// () => InkWell(
// onTap: () {
// selectController.updateColor(index);
// setState(() {
// currentIndex = index;
// });
// },
// child: Column(
// children: [
// Container(
// width: 63.3,
// child: Center(
// child: SvgPicture.asset(
// iconList[index],
// height: 20,
// width: 20,
// fit: BoxFit.fill,
// color: selectController
//     .listofBool[index] ==
// true
// ? buttonColor
//     : Colors.black)),
// decoration: BoxDecoration(
// borderRadius:
// BorderRadius.circular(3),
// color: Colors.white),
// ),
// SizedBox(height: 2,),
// Text(textList[index],style: TextStyle(fontSize: 12),),
// ],
// ),
// ),
// );
// }).toList(),
// ),
// ))
