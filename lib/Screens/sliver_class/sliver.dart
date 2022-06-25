import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rooya/Models/StoryViewsModel.dart';
import 'package:rooya/Providers/ClickController/SelectIndexController.dart';
import 'package:rooya/Screens/Information/UserChatInformation/user_chat_information.dart';
import 'package:rooya/Screens/SearchUser/SearchUser.dart';
import 'package:rooya/Screens/Settings/Settings.dart';
import 'package:rooya/Screens/chat_screen.dart';
import 'package:rooya/Utils/UserDataService.dart';
import 'package:rooya/Utils/text_filed/app_font.dart';

import '../../Models/FriendsListModel.dart';
import '../../Models/UserChatModel.dart';
import '../../Models/UserStoriesModel.dart';
import '../../Providers/ChatScreenProvider.dart';
import '../../Utils/StoryViewPage.dart';
import '../../Utils/primary_color.dart';

class MySliver extends StatefulWidget {
  final Messages? model;
  const MySliver({Key? key, this.model}) : super(key: key);

  @override
  _MySliverState createState() => _MySliverState();
}

var hasUserStory = false.obs;
var allstoryList = <UserStoryModel>[];
var storyIds = [];
var storyLoaded = false.obs;

class _MySliverState extends State<MySliver> {
  var selectController = Get.find<SelectIndexController>();
  final controller = Get.put(ChatScreenProvider());
  var listOfSelectedMember = <Data>[].obs;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 9,
          ),
          ListTile(
              leading: Obx(
                () => hasUserStory.value
                    ? CircularProfileAvatar(
                        '${UserDataService.userDataModel!.userData!.avatar}',
                        radius: 18,
                        borderWidth: 2,
                        borderColor: buttonColor,
                        backgroundColor: Colors.blueGrey[100]!,
                        onTap: () {
                          int i = storyIds.indexWhere((element) =>
                              element ==
                              '${UserDataService.userDataModel!.userData!.userId.toString()}');
                          context.pushTransparentRoute(StoryViewPage(
                            userStories: allstoryList[i],isAdmin: true,
                          ));
                        },
                      )
                    : CircularProfileAvatar(
                        '${UserDataService.userDataModel!.userData!.avatar}',
                        radius: 18,
                        backgroundColor: Colors.blueGrey[100]!,
                        onTap: () {
                          Get.to(UserChatInformation(
                              userID:
                                  '${UserDataService.userDataModel!.userData!.userId}'));
                        },
                      ),
              ),

              title: Container(
                height: 26,
                width: 100,
                decoration: BoxDecoration(color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(18),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search here...',
                    hintStyle: TextStyle(fontSize: 12),
                    isDense: true,
                    prefixIcon: Icon(Icons.search,color:  Colors.green,
                    )
                  ),
                ),
              ),
              trailing: Wrap(
                children: [
                  // InkWell(
                  //   child: Icon(
                  //     CupertinoIcons.search,
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (c) => SearchUser()));
                  //   },
                  // ),
                  InkWell(
                      onTap: () {
                        // return createAlertDialoge1(context);
                      },
                      child: Icon(
                        CupertinoIcons.bell_solid,
                        color: Colors.black,
                        size: 23,
                      )),
                  InkWell(
                      onTap: () {
                        Get.to(Settings());
                      },
                      child: Container(
                        height: 20,
                        width: 20,
                        child: SvgPicture.asset('assets/user/setting.svg'),
                      )),
                ],
                spacing: 8,
              )),

          Obx(()=> !storyLoaded.value?SizedBox(): Container(
              height: 70,
              //color: Colors.green,
              child: ListView.builder(itemCount: controller.storyList.length,itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 30,
                  width: 55,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CircularProfileAvatar(
                    '${controller.storyList[index].stories![0].thumbnail}',
                    borderWidth: 2,
                    borderColor: buttonColor,
                    backgroundColor: Colors.blueGrey[100]!,
                    onTap: listOfSelectedMember
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
                                  .storyList[index],
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
                  ),
                ),
              ) ,scrollDirection: Axis.horizontal,),
            ),
          )
          // Container(
          //   height: height * 0.045,
          //   width: width,
          //   margin: EdgeInsets.symmetric(horizontal: 10),
          //   padding: EdgeInsets.only(left: 10, right: 0),
          //   child: TextFormField(
          //     onChanged: (value) {
          //       selectController.search.value = value;
          //       print('selectController search is = ${selectController.search.value}');
          //     },
          //     style: TextStyle(fontSize: 14),
          //     decoration: InputDecoration(
          //       disabledBorder: new OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(30),
          //           borderSide: new BorderSide(
          //             color: Colors.black12,
          //           )),
          //       focusedBorder: new OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(30),
          //           borderSide: new BorderSide(
          //             color: Colors.black12,
          //           )),
          //       enabledBorder: new OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(30),
          //           borderSide: new BorderSide(
          //             color: Colors.black12,
          //           )),
          //       border: new OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(30),
          //           borderSide: new BorderSide(
          //             color: Colors.black12,
          //           )),
          //       isDense: true,
          //       hintText: 'Search here ...',
          //       hintStyle: TextStyle(fontSize: 10, color: Colors.black),
          //       suffixIcon: Icon(
          //         Icons.search,
          //         size: 20,
          //         color: Color(0XFF0BAB0D),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  createAlertDialoge1(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              insetPadding: EdgeInsets.only(left: 15, right: 15),
              content: Container(
                  height: 260,
                  width: 350,
                  //color: Colors.green,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 115),
                          child: Text(
                            'Steven',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                                fontFamily: AppFonts.segoeui),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0XFFF9F9F9),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'online',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: AppFonts.segoeui),
                                ),
                                Icon(Icons.arrow_drop_down_outlined)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CircularProfileAvatar(
                      '',
                      radius: 60,
                      //backgroundColor: Colors.red,
                      child: Image(
                        image: AssetImage('assets/user/logooo.png'),
                      ),
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
                  ])));
        });
  }
}


// InkWell(
// onTap: () {
// if(hasUserStory.value){
// int i = storyIds.indexWhere((element) =>
// element ==
// '${UserDataService.userDataModel!.userData!.userId.toString()}');
// Get.to(UserChatInformation(
// userID:
// '${UserDataService.userDataModel!.userData!.userId}',userStory: allstoryList[i],));
// }else{
// Get.to(UserChatInformation(
// userID:
// '${UserDataService.userDataModel!.userData!.userId}'));
// }
// },
// child: Text(
// UserDataService.userDataModel!.userData!.firstName!.isEmpty
// ? '${UserDataService.userDataModel!.userData!.username}'
// : '${UserDataService.userDataModel!.userData!.firstName} ${UserDataService.userDataModel!.userData!.lastName}',
// style: TextStyle(
// fontSize: 15,
// fontWeight: FontWeight.bold,
// fontFamily: AppFonts.segoeui),
// ),
// )