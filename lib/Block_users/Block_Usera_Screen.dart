import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/Screens/chat_screen.dart';

import '../ApiConfig/ApiUtils.dart';
import '../ApiConfig/BaseURL.dart';
import '../GlobalWidget/ConfirmationDialog.dart';
import '../Providers/ChatScreenProvider.dart';
import 'Unblock_Provider.dart';

class BlockUsersScreenList extends StatefulWidget {
  String? userId;
   BlockUsersScreenList({Key? key,this.userId}) : super(key: key);

  @override
  _BlockUsersScreenListState createState() => _BlockUsersScreenListState();
}

class _BlockUsersScreenListState extends State<BlockUsersScreenList> {
  bool unblocked = false;
  var controller = Get.put(UnBlockPtovider());
  final controllerr = Get.put(ChatScreenProvider());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print('jkjkk${controller.BlockList.length}');
    return Scaffold(
      appBar: AppBar(title: Text('Block Users')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Obx(()=>ListView.builder(itemCount: controller.BlockList.length,itemBuilder: (context, index) => ListTile(
                leading: CircularProfileAvatar('',
                  child: Image.network('${controllerr.listofChat[index].avatar}'),
                  backgroundColor: Colors.green,
                  radius: 25,
                ),
                title: Text('${controllerr.listofChat[index].username}'),
                trailing: ElevatedButton(
                  child: Text('UnBlock'),
                  onPressed: (){
                    // Future.delayed(Duration(),
                    //         () async {
                    //       await showAlertDialog(
                    //           context: context,
                    //           content:
                    //           'You want to Unblock User?',
                    //           cancel: () {
                    //             Navigator.of(context)
                    //                 .pop();
                    //           },
                    //           done: () async {
                    //             Map map = {
                    //               'server_key':
                    //               serverKey,
                    //             };
                    //             await ApiUtils
                    //                 .unblockedUser(
                    //                 map: map);
                    //             Navigator.of(context)
                    //                 .pop();
                    //           });
                    //       setState(() {});
                    //     });
                  },
                  style: ButtonStyle(backgroundColor:  MaterialStateProperty.all(Colors.greenAccent)),
                ),
              ),),)
            ),
          ),

        ],
      ),
    );
  }
}
