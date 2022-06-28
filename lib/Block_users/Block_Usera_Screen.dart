import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/Screens/chat_screen.dart';
import '../ApiConfig/ApiUtils.dart';
import '../ApiConfig/BaseURL.dart';
import 'BlockUserProvider.dart';

class BlockUsersScreenList extends StatefulWidget {
  String? userId;
  BlockUsersScreenList({Key? key, this.userId}) : super(key: key);

  @override
  _BlockUsersScreenListState createState() => _BlockUsersScreenListState();
}

class _BlockUsersScreenListState extends State<BlockUsersScreenList> {
  bool unblocked = false;
  var controller = Get.put(BlockUserProvider());
  @override
  void initState() {
    controller.getListofblockUser();
    super.initState();
  }

  int progressbar_index = 1000;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Block Users')),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Obx(
                  () => !controller.loadData.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: controller.listOfBlockUser.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: CircularProfileAvatar(
                              '',
                              child: Image.network(
                                  '${controller.listOfBlockUser[index].avatar}'),
                              backgroundColor: Colors.green,
                              radius: 25,
                            ),
                            title: Text(
                                '${controller.listOfBlockUser[index].username}'),
                            trailing: index == progressbar_index
                                ? Container(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 3),
                                    height: 15,
                                    width: 15)
                                : ElevatedButton(
                                    child: Text('UnBlock'),
                                    onPressed: () async {
                                      progressbar_index = index;
                                      setState(() {});
                                      Map map = {
                                        'server_key': serverKey,
                                        'user_id': controller
                                            .listOfBlockUser[index].userId,
                                        'block_action': 'un-block'
                                      };
                                      await ApiUtils.blockUnblockUser(map: map);
                                      controller.listOfBlockUser
                                          .removeAt(index);
                                      setState(() {});
                                    },
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.greenAccent)),
                                  ),
                          ),
                        ),
                )),
          ),
        ],
      ),
    );
  }
}
