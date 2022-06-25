import 'dart:convert';
import 'package:flutter/cupertino.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
    return SafeArea(
        child: Scaffold(
          key: scaffoldStateKey,
            drawer: Drawer(
              width: 220,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    CircularProfileAvatar('',
                    radius: 50,
                      //backgroundColor: Colors.green,
                      child: Image.network('${UserDataService.userDataModel!.userData!.avatar}'),
                    ),
                    SizedBox(height: 15,),
                    InkWell(
                      onTap: (){
                        Get.to(
                            UserChatInformation(
                                userID:
                                '${UserDataService.userDataModel!.userData!.userId}')
                        );
                      },
                      child: Text('${UserDataService.userDataModel!.userData!.firstName}  ${UserDataService.userDataModel!.userData!.lastName}',style:
                        TextStyle(fontWeight: FontWeight.bold,fontSize: 20,),),
                    ),
                    SizedBox(height: 8,),
                    Text('${UserDataService.userDataModel!.userData!.username}@',style: TextStyle(fontSize: 20),),
                  Divider(height: 20,color: Colors.grey,),
                    ListTile(
                      onTap: (){
                        Get.to(Apearennce());
                      },
                      title: Text('Appearance',style: TextStyle(fontSize: 16),),
                    ),
                    ListTile(
                      title: Text('Block Users',style: TextStyle(fontSize: 16),),
                    ),
                    ListTile(
                      onTap: (){
                        Get.to(Settings());
                      },
                      title: Text('Settings',style: TextStyle(fontSize: 16),),
                    ),
                    ListTile(
                      onTap: (){
                        var selectController = Get.find<SelectIndexController>();
                        // final controller = Get.find<GroupProvider>();
                        selectController.updateColor(0);
                        // controller.listofMember.value=[];
                        storage.erase();
                        Get.deleteAll();
                        Get.offAll(SignInTabsHandle());
                      },
                      title: Text('Logout',style: TextStyle(fontSize: 16,color: Colors.red),),
                    )
                  ],
                ),
              )
            ),
            backgroundColor: Colors.white,
            body: DefaultTabController(
                length: 3,
                child: NestedScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    headerSliverBuilder: (context, isScrool) {
                      return [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          elevation: 0,
                          collapsedHeight: height * 0.200,
                          backgroundColor: Colors.white,
                          expandedHeight: height * 0.130,
                          bottom: TabBar(
                            onTap: (w){
                              setState(() {
                                //indexColors = false;
                              });
                            },
                            indicatorColor: Colors.green,
                            indicatorWeight: 2,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: [
                              Tab(
                                height: 40,
                                child: Column(
                                children: [
                                  SvgPicture.asset('assets/user/prs.svg',color: Colors.black,),
                                  SizedBox(height: 3,),
                                  Text('Chat',style: TextStyle(color: Colors.black),),
                                ],
                              ),),
                              Tab(
                                height: 40,
                                child: Column(
                                children: [
                                  SvgPicture.asset('assets/user/persons.svg',),
                                  Text('Groups',style: TextStyle(color: Colors.black),),
                                ],
                              ),),
                              Tab(
                                height: 40,
                                child: Column(
                                children: [
                                  SvgPicture.asset('assets/user/sw.svg',),
                                  Text('Rooms',style: TextStyle(color: Colors.black),),
                                ],
                              ),),
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
                    ),))));
  }
  Widget openDrawer(BuildContext context){
    return Drawer(
      width: 300,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            radius: 20,
          ),
          Text('the man of the end'),
        ],
      ),
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