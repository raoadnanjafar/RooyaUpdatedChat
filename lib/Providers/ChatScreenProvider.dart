import 'dart:io';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/BaseURL.dart';
import 'package:rooya/GlobalWidget/FileUploader.dart';
import 'package:rooya/Models/FriendsListModel.dart' as friendmodel;
import 'package:rooya/Models/OneTwoOneOuterModel.dart';
import 'package:rooya/Models/UserStoriesModel.dart';
import 'package:rooya/Utils/UserDataService.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:dio/dio.dart' as dio;

import '../Models/UserChatModel.dart';
import '../Screens/sliver_class/sliver.dart';

class ChatScreenProvider extends GetxController {
  var listofChat = <Data>[].obs;
  var loadChat = false.obs;
  Future getChatList() async {
    OneToOneChatOuterModel v = await ApiUtils.getGroup(
        limit: 100,
        start: 0,
        mapData: {'server_key': serverKey, 'data_type': 'users'});
    print('pharse data is =${v.apiStatus}');
    if (v.apiStatus == 200) {
      listofChat.value = v.data!;
    }
    loadChat.value = true;
  }

  Socket? socket;
  String alreadyOpenGroup = '';

  //https://xd.rooya.com:449/?hash=9c693d1979dc33cfa0e0
  connectToSocket() {
    try {
      socket = io(
          '$socketURL',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
      socket!.connect();
      socket!.on('connect', (value) {
        print('connect to server');
        socket!.emit(
          'join',
          {
            "username": "${UserDataService.userDataModel!.userData!.username}",
            'user_id': '${storage.read('token')}',
          },
        );
        socket!.on("private_message_page", (data) {
          print('private_message_page');
          getChatList();
        });
      });
    } catch (e) {
      print('Exception =$e');
    }
  }

  leaveGroup() {
    socket!.close();
    socket!.disconnect();
    socket!.dispose();
  }

  var friendList = <friendmodel.Following>[].obs;
  Future getFriendList() async {
    friendList.value = await ApiUtils.allFriendList(limit: 50, start: 0);
  }

  var idsOfUserStories = [];
  var storyList = <UserStoryModel>[].obs;
  Future getStoryList() async {
     idsOfUserStories = [];
     storyList = <UserStoryModel>[].obs;
    storyList.value =
        await ApiUtils.getAllStoriesData(mapData: {'server_key': serverKey});
    for (var i in storyList) {
      idsOfUserStories.add(i.userId);
    }
     hasUserStory.value=false;
    if (idsOfUserStories.contains(
        UserDataService.userDataModel!.userData!.userId.toString())) {
      hasUserStory.value=true;
      allstoryList=storyList.value;
      storyIds=idsOfUserStories;

    }
    storyLoaded.value = true;
  }

  sentMessageViaFile({String? filePath, String? groupId}) async {
    var file = File(filePath!);
    String fileName = file.path.split('/').last;
    Map<String, dynamic> data = {
      'memberId': storage.read('userID'),
      'groupId': '$groupId',
      'file': await dio.MultipartFile.fromFile(
        '${file.path}',
        filename: '$fileName',
      )
    };
    sendFileMessage(data);
  }

  var isLoading = false.obs;
}
