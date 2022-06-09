import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/BaseURL.dart';
import 'package:rooya/GlobalWidget/FileUploader.dart';
import 'package:rooya/Models/FriendsListModel.dart';
import 'package:rooya/Models/UserChatModel.dart';
import 'package:rooya/Utils/UserDataService.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:dio/dio.dart' as dio;

import '../chat_screen.dart';

class UserChatProvider extends GetxController {
  var startTyping = false.obs;
  var searchText = ''.obs;
  var isReciverTyping = false.obs;
  var isOnline = false.obs;

  checkTypnigStatus({String? groupId}) {
    debounce(searchText, (value) {
      socket!.emit('typing_done', {'userId': '${storage.read('token')}'});
      startTyping.value = false;
    }, time: Duration(milliseconds: 500));
  }

  userTypingStart({String? groupId}) {
    socket!.emit('typing', {'userId': '${storage.read('token')}'});
  }

  var userChat = <Messages>[].obs;
  String groupID = '';
  bool firstTime = false;
  Future getAllMessage({String? userID, bool? fromGroup = false}) async {
    groupID = userID!;
    if (!fromGroup!) {
      print('object = ${{'server_key': serverKey, 'recipient_id': userID}}');
      userChat.value = await ApiUtils.getMessage_list(
          map: {'server_key': serverKey, 'recipient_id': userID},
          start: 0,
          limit: 100);
    } else {
      userChat.value = await ApiUtils.getMessage_list_forGroup(map: {
        'server_key': serverKey,
        'type': 'fetch_messages',
        'id': '$userID'
      }, start: 0, limit: 100);
    }
    sendSmsStreamcontroller.add(0.0);
    if (!firstTime) {
      socket!.emit("seen_messages", {
        'user_id': '${storage.read('token')}',
        'recipient_id': '$groupID',
        'message_id': '${userChat.last.id}'
      });
      firstTime = true;
    }
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

  Socket? socket;
  bool isRecive = false;

  onConnectScocket({String? groupID, bool? fromGroup = false}) {
    try {
      socket = io(
          '$socketURL',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
      // socket!.close();
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
        socket!.on('typing', (value) {
          print('userTyping $value');
          if (value['is_typing'] == 200) {
            isReciverTyping.value = true;
          } else {
            isReciverTyping.value = false;
          }
        });
        socket!.on('lastseen', (value) {});
        if (fromGroup!) {
          socket!.on('group_message', (value) {
            //  log('group_message is = $value');
            // // oneToOneChat.insert(0, OneToOneChatModel.fromJson(value));
            // if (groupID != '') {
            //   getAllMessage(userID: groupID, fromGroup: fromGroup);
            // }
            Messages message = Messages.fromJson(value['message_res']);
            // if (groupID != '') {
            //   getAllMessage(userID: groupID,fromGroup: fromGroup);
            // }
            userChat.insert(0, message);
            socket!.emit("seen_messages", {
              'user_id': '${storage.read('token')}',
              'recipient_id': '$groupID',
              'message_id': '${message.id}'
            });
            sendSmsStreamcontroller.add(0.0);
          });
        } else {
          socket!.on('private_message', (value) {
            // log('newMessage private_message is = $value');
            Messages message = Messages.fromJson(value['message_res']);
            // if (groupID != '') {
            //   getAllMessage(userID: groupID,fromGroup: fromGroup);
            // }
            userChat.insert(0, message);
            socket!.emit("seen_messages", {
              'user_id': '${storage.read('token')}',
              'recipient_id': '$groupID',
              'message_id': '${message.id}'
            });
            sendSmsStreamcontroller.add(0.0);
          });
        }
        socket!.on("lastseen", (data) {
          print('get last seen');
          getAllMessage(userID: groupID, fromGroup: fromGroup);
        });
        socket!.on("msg_delivered", (data) {
          print('message delivered now');
        });
        // socket!.on('receiveSeen', (value) {
        //   print('receiveSeen = $value');
        //   if (!isRecive) {
        //     isRecive = true;
        //     if (groupID != '') {
        //       getAllMessage(userID: groupID);
        //     }
        //     Future.delayed(Duration(seconds: 2), () {
        //       isRecive = false;
        //     });
        //   }
        // });
        // socket!.on('updateStatus', (value) {
        //   print('updateStatus app = $value');
        //   if (value['status'] == 1) {
        //     isOnline.value = true;
        //   } else {
        //     isOnline.value = false;
        //   }
        //   if (groupID != '') {
        //     getAllMessage(userID: groupID);
        //   }
        // });
        // socket!.on('blockStatus', (value) {
        //   print('blockStatus is = $value');
        //   if (value['block'] == 0) {
        //     block_user.value = false;
        //   } else {
        //     block_user.value = true;
        //   }
        // });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  var block_user = false.obs;

  onSentMessage(
      {String? message,
      String? to_userId,
      bool? fromGroup,
      String? replyID = ''}) {
    try {
      if (fromGroup!) {
        if (replyID != '') {
          socket!.emit('group_message', {
            'msg': message,
            'group_id': to_userId,
            'from_id': '${storage.read('token')}',
            'username': '${UserDataService.userDataModel!.userData!.username}',
            'message_reply_id': replyID
          });
        } else {
          socket!.emit('group_message', {
            'msg': message,
            'group_id': to_userId,
            'from_id': '${storage.read('token')}',
            'username': '${UserDataService.userDataModel!.userData!.username}',
          });
        }
        getAllMessage(userID: to_userId, fromGroup: fromGroup);
        Future.delayed(Duration(seconds: 1), () {
          getAllMessage(userID: to_userId, fromGroup: fromGroup);
        });
      } else {
        if (replyID != '') {
          print('has reply id$replyID');
          socket!.emit('private_message', {
            'msg': message,
            'to_id': to_userId,
            'from_id': '${storage.read('token')}',
            'username': '${UserDataService.userDataModel!.userData!.username}',
            'message_reply_id': replyID
          });
        } else {
          socket!.emit('private_message', {
            'msg': message,
            'to_id': to_userId,
            'from_id': '${storage.read('token')}',
            'username': '${UserDataService.userDataModel!.userData!.username}',
          });
        }
        getAllMessage(userID: to_userId, fromGroup: fromGroup);
        Future.delayed(Duration(seconds: 1), () {
          getAllMessage(userID: to_userId, fromGroup: fromGroup);
        });
      }
    } catch (e) {
      print('send message exaption is = $e');
    }
  }

  leaveRoom({String? groupId}) {
    groupID = '';
    socket!.emit('leaveRoom', int.parse(groupId!));
    socket!.close();
    socket!.dispose();
    socket!.disconnect();
    firstTime = true;
  }

  var recording_start = false.obs;

  final ImagePicker _picker = ImagePicker();

  Future<String> onImageButtonPressed(
      {ImageSource? source, String? tag}) async {
    try {
      final pickedFile;
      if (tag == 'image') {
        pickedFile = await _picker.getImage(
          source: source!,
        );
        if (pickedFile!.path != null) {
          return '${pickedFile!.path}';
        } else {
          return '';
        }
      } else {
        pickedFile = await _picker.getVideo(
          source: source!,
        );
        if (pickedFile!.path != null) {
          return '${pickedFile!.path}';
        } else {
          return '';
        }
      }
    } catch (e) {}
    return '';
  }

  var friendList = <Following>[].obs;
  Future getFriendList() async {
    friendList.value = await ApiUtils.allFriendList(limit: 50, start: 0);
  }
}
