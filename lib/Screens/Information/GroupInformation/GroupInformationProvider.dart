import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/BaseURL.dart';
import 'package:rooya/Models/FriendsListModel.dart';
import 'package:rooya/Models/GroupModel.dart';
import 'package:story_view/story_view.dart';

import '../../../GlobalWidget/FileUploader.dart';
import '../../../Models/StoryViewsModel.dart';

class GroupInformationConntroller extends GetxController {
  var listofChat = <GroupModel>[].obs;
  Future<GroupModel> getGroupList(String groupID) async {
    listofChat.value = await ApiUtils.getMainGroup(limit: 100, start: 0, mapData: {'server_key': serverKey, 'data_type': 'groups'});
    for (var i in listofChat) {
      if (i.groupId.toString() == groupID) {
        return i;
      }
    }
    return GroupModel(groupId: '');
  }

  var friendList = <Following>[].obs;
  Future getFriendList() async {
    friendList.value = await ApiUtils.allFriendList(limit: 50, start: 0);
  }
}

class StoryInformationConntroller extends GetxController {
  var listofStory = storyViewModel().obs;
  var loadData = false.obs;
  Future getStoryList(String userID) async {
    listofStory.value = await ApiUtils.storyView(mapData: {'server_key': serverKey, 'story_id': userID});
    loadData.value = true;
  }
}

