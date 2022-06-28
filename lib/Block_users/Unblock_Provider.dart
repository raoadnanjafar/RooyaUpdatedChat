import 'dart:convert';

import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/BaseURL.dart';
import 'package:http/http.dart'as http;
import 'Unblocked_Model.dart';

class UnBlockPtovider extends GetxController{
  var BlockList = <blockedModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    UnblockedData();
    super.onInit();
  }
  Future UnblockedData()async{

    blockedModel model = await ApiUtils.unblockedUser(
      map: {
        'server_key': serverKey
      }
    );
    if(model.apiStatus == 200){
      BlockList.value = model.blockedUsers!;
    }
    isLoading.value = true;
    // var response =await http.post(Uri.parse('$baseUrl$getUnBlockedUsers$token'),body: {
    //   'server_key': serverKey,
    // });
    // var dataH = jsonDecode(response.body);
    // blockedModel modelList = blockedModel.fromJson(dataH);
    // BlockList.value = modelList.blockedUsers!;
    // if (dataH['api_status'] == true) {
    //   print('status code ${response.statusCode}');
    //
    //   isLoading.value = true;
    // }
  }
}