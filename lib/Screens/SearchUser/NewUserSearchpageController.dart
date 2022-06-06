import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import '../../Models/FriendsListModel.dart';

class NewUserSearchPageController extends GetxController {
  var friendList = <Following>[].obs;
  Future getFriendList() async {
    friendList.value = await ApiUtils.allFriendList(limit: 50, start: 0);
  }
}
