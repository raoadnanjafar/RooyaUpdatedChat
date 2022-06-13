import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/GlobalWidget/FileUploader.dart';

import '../../../Plugins/PicEditor/image_editor.dart';
import 'VideoEditorCustom.dart';

class SendSmsView extends StatefulWidget {
  final String? userID;
  final String? path;
  final String? extention;
  final String? replyId;

  const SendSmsView({
    Key? key,
    this.userID,
    this.path,
    this.extention,
    this.replyId = '',
  }) : super(key: key);

  @override
  State<SendSmsView> createState() => _SendSmsViewState();
}

class _SendSmsViewState extends State<SendSmsView> {
  TextEditingController captionController = TextEditingController();
  var loading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
              backgroundColor: Colors.black,
              body: Stack(
                children: [
                  Container(
                    height: height * 0.9,
                    width: width,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            width: MediaQuery.of(context).size.width,
                            child: widget.extention == 'image'
                                // ? ImageEditor(
                                //     image: File('${widget.path}').readAsBytesSync(),
                                //   )
                                ? ImageEditor(
                                    originImage: File(widget.path!),
                                    doneFile: (File file) async {
                                      await sentMessageAsFile(
                                              userID: widget.userID,
                                              text: captionController.text,
                                              filePath: file.path,
                                              replyid: widget.replyId)
                                          .then((value) {
                                        loading.value = false;
                                        Get.back(result: 'fetch');
                                      });
                                      loading.value = false;
                                    },
                                  )
                                : VideoEditorCustom(
                                    file: File('${widget.path}'),
                                    doneFile: (File file) async {
                                      await sentMessageAsFile(
                                              userID: widget.userID,
                                              text: captionController.text,
                                              filePath: file.path,
                                              replyid: widget.replyId)
                                          .then((value) {
                                        loading.value = false;
                                        Get.back(result: 'fetch');
                                      });
                                      loading.value = false;
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: loading.value,
                      child: InkWell(
                        onTap: () {
                          loading.value = false;
                        },
                        child: Container(
                          height: height,
                          width: width,
                          child: Center(
                            child: SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  )
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.070,
              margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 18),
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Add a Caption',
                  hintStyle: TextStyle(color: Colors.greenAccent),
                  prefixIcon: Icon(
                    Icons.image,
                    color: Colors.greenAccent,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        loading.value = true;
                        videoStreamcontroller.add(0.0);
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.greenAccent,
                      )),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  sendsms() {}
}
