import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/Models/BlockUser.dart';

class BlockUserProvider extends GetxController{
  var listOfBlockUser=<BlockUser>[].obs;
  var loadData=false.obs;
  getListofblockUser()async{
    listOfBlockUser.value=await ApiUtils.getBlockedUser();
    loadData.value=true;
  }
}