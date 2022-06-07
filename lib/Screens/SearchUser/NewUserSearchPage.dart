import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/GlobalWidget/Photo_View_Class.dart';

import '../../Models/FriendsListModel.dart';
import '../UserChat/UserChat.dart';
import 'NewUserChatPage.dart';
import 'NewUserSearchpageController.dart';
import 'SearchUser.dart';
import 'SearchUserController.dart';

class NewUserSearchpage extends StatefulWidget {
  final List<Following>? listofFriend;
  const NewUserSearchpage({Key? key, required this.listofFriend})
      : super(key: key);

  @override
  _NewUserSearchpageState createState() => _NewUserSearchpageState();
}

class _NewUserSearchpageState extends State<NewUserSearchpage> {
  var controller = Get.put(NewUserSearchPageController());

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 50), () {
      controller.friendList.value = widget.listofFriend!;
    });
    openSearch = true;
    controller.getFriendList();
    super.initState();
  }

  bool isloading = false;

  @override
  void dispose() {
    openSearch = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 30,
        elevation: 0,
        title: Container(
          height: Get.height * 0.045,
          width: Get.width,
          padding: EdgeInsets.only(left: 10, right: 0),
          child: TextFormField(
            onChanged: (value) {
              // selectController.search.value = value;
              // print('selectController search is = ${selectController.search.value}');
            },
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              disabledBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: new BorderSide(
                    color: Colors.black12,
                  )),
              focusedBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: new BorderSide(
                    color: Colors.black12,
                  )),
              enabledBorder: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: new BorderSide(
                    color: Colors.black12,
                  )),
              border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: new BorderSide(
                    color: Colors.black12,
                  )),
              isDense: true,
              hintText: 'Search here ...',
              hintStyle: TextStyle(fontSize: 10, color: Colors.black),
              suffixIcon: Icon(
                Icons.search,
                size: 20,
                color: Color(0XFF0BAB0D),
              ),
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.030,
                ),
                Expanded(
                  child: Obx(
                    () => controller.friendList.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemBuilder: (c, i) {
                              return ListTile(
                                leading: CircularProfileAvatar(
                                  '${controller.friendList[i].avatar}',
                                  elevation: 2,
                                  radius: 23,
                                  imageFit: BoxFit.cover,
                                  onTap: () {
                                    Get.to(Photo_View_Class(
                                      url: '${controller.friendList[i].avatar}',
                                    ));
                                  },
                                ),
                                title: Text(
                                  controller.friendList[i].firstName!.isEmpty
                                      ? '${controller.friendList[i].username}'
                                      : '${controller.friendList[i].firstName} ${controller.friendList[i].lastName}',
                                  style: TextStyle(fontSize: 15),
                                ),
                                onTap: () async {
                                  // Map map = {
                                  //   'message': '',
                                  //   'memberId[]':
                                  //       '${controller.searchUserModel.value.friends![i].userId}'
                                  // };
                                  // setState(() {
                                  //   isloading = true;
                                  // });
                                  // await ApiUtils.sendMessagepost(map: map);
                                  // setState(() {
                                  //   isloading = false;
                                  // });
                                  // Get.to(NewUserChatPage(
                                  //   userID:
                                  //       '${controller.searchUserModel.value.friends![i].userId}',
                                  //   name:
                                  //       '${controller.searchUserModel.value.friends![i].firstName} ${controller.searchUserModel.value.friends![i].lastName}',
                                  //   profilePic:
                                  //       '${controller.searchUserModel.value.friends![i].profilePictureUrl}',
                                  // ));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => UserChat(
                                                groupID: controller
                                                    .friendList[i].userId
                                                    .toString(),
                                                blocked: false,
                                                name: controller
                                                        .friendList[i].firstName
                                                        .toString()
                                                        .isEmpty
                                                    ? controller
                                                        .friendList[i].username
                                                        .toString()
                                                    : controller.friendList[i]
                                                            .firstName
                                                            .toString() +
                                                        controller.friendList[i]
                                                            .lastName
                                                            .toString(),
                                                profilePic: controller
                                                    .friendList[i].avatar,
                                                fromGroup: false,
                                              ))).then((value) => Get.back());
                                },
                              );
                            },
                            itemCount: controller.friendList.length,
                          ),
                  ),
                )
              ],
            ),
          ),
          isloading
              ? Container(
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.3)),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
