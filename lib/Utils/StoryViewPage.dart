import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/GlobalWidget/SnackBarApp.dart';
import 'package:rooya/Models/UserStoriesModel.dart';
import 'package:rooya/Screens/chat_screen.dart';
import 'package:rooya/Utils/StoryViewScreen.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'dart:io' show Platform;
import '../ApiConfig/BaseURL.dart';
import '../GlobalWidget/FileUploader.dart';
import '../Models/StoryView.dart';
import '../Models/StoryViewsModel.dart';
import '../Screens/Information/UserChatInformation/user_chat_information.dart';
import 'UserDataService.dart';

class StoryViewPage extends StatefulWidget {
  final Socket? socket;
  final UserStoryModel? userStories;
  final bool? isAdmin;
  final Function(String)? swipCallBack;
  const StoryViewPage({
    Key? key,
    this.userStories,
    this.isAdmin = false,
    this.socket,
    this.swipCallBack,
  }) : super(key: key);

  @override
  _StoryViewPageState createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage>
    with SingleTickerProviderStateMixin {
  final StoryController controller = StoryController();
  bool? storyLoaded;
  int currentIndex = 0;
  storyViewModel? model;
  var totalView = 10000.obs;
  @override
  void initState() {
    Future.delayed(Duration(), () async {
      model = await ApiUtils.storyView(mapData: {
        'server_key': serverKey,
        'story_id':
            '${widget.userStories!.stories![currentIndex].id.toString()}'
      });
      totalView.value = model!.users!.length;
    });
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    animation = Tween(
      begin: const Offset(0.0, 0.5),
      end: const Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        curve: Curves.decelerate,
        parent: _controller,
      ),
    );
  }

  late AnimationController _controller;
  late Animation<Offset> animation;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  PageController pageController =
      PageController(initialPage: 0, keepPage: false);

  bool openSheet = false;
  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        //Navigator.of(context).pop();
      },
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          print('Drag one ${details.delta.dy}');
          if (details.delta.dy < -1.0) {
            print('Drag two');
            _controller.forward().whenComplete(() => _controller.reverse());
            Future.delayed(Duration(milliseconds: 500), () {
              if (openSheet == false && widget.isAdmin!) {
                openSheet = true;
                controller.pause();
                storyPreview(widget.userStories!.stories![currentIndex].id
                        .toString())
                    .then((value) {
                  controller.play();
                  openSheet = false;
                });
              } else {
                if (openSheet == false) {
                  openSheet = true;
                  controller.pause();
                  replyPreview(
                    widget.userStories!.stories![currentIndex].id.toString(),
                  ).then((value) {
                    controller.play();
                    openSheet = false;
                    if (value == 'send') {
                      snackBarSuccess(
                          'Message sent successfully to ${widget.userStories!.firstName} ${widget.userStories!.lastName}');
                    }
                  });
                }
              }
            });
          }
          if (details.delta.dy > 1.0) {
            bool pop = false;
            if (!pop) {
              pop = true;
              Navigator.of(context).pop();
            }
            print('Drag up now');
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  bool drag = true;
                  if (drag && widget.swipCallBack != null) {
                    drag = false;
                    if (details.delta.dx < -1) {
                      widget.swipCallBack!.call('next');
                    } else {
                      widget.swipCallBack!.call('back');
                    }
                  }
                },
                child: Container(
                  height: height,
                  width: width,
                  child: StoryView(
                    controller: controller,
                    currentIndex: (int c) async{
                      print('currentIndex = $c');
                      currentIndex = c + 1;
                      model = await ApiUtils.storyView(mapData: {
                        'server_key': serverKey,
                        'story_id':
                            '${widget.userStories!.stories![currentIndex].id.toString()}'
                      });
                      totalView.value = model!.users!.length;
                    },
                    storyItems: widget.userStories!.stories!.map((e) {
                      if (e.videos == null || e.videos!.isEmpty) {
                        return StoryItem.inlineImage(
                          url: "${e.thumbnail}",
                          controller: controller,
                          imageFit: BoxFit.contain,
                          duration: Duration(seconds: 10),
                          caption: Text(
                            "${e.description}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.black54,
                              fontSize: 17,
                            ),
                          ),
                        );
                      } else {
                        return StoryItem.pageVideo(
                          '${e.videos![0].filename}',
                          controller: controller,
                          caption: "${e.description}",
                          duration: Duration(seconds: e.videos![0].totalTime!),
                        );
                      }
                    }).toList(),
                    onStoryShow: (s) {
                      print("Showing a story");
                    },
                    onComplete: () {
                      if (widget.swipCallBack == null) {
                        print("Completed a cycle");
                        Navigator.pop(context);
                      }
                      if (widget.userStories!.stories!.length ==
                          currentIndex + 1) {
                        widget.swipCallBack!.call('next');
                      }
                    },
                    progressPosition: ProgressPosition.top,
                    repeat: false,
                    inline: true,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 10),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 40),
                          child: InkWell(
                            onTap: () {
                              controller.pause();
                              Get.to(UserChatInformation(
                                      userID: widget.userStories!.userId
                                          .toString()))
                                  ?.then((value) => controller.play());
                            },
                            child: Text(
                              '${widget.userStories!.username}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 70),
                      child: Text(
                        '${widget.userStories!.stories![currentIndex].timeText}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.remove_red_eye,
              //     color: Colors.white,
              //   ),
              //   onPressed: () {
              //     if (storyLoaded = true) {
              //       controller.pause();
              //       storyPreview(widget
              //           .userStories!.stories![currentIndex].id
              //           .toString())
              //           .then((value) {
              //         controller.play();
              //       });
              //     }
              //   },
              // )
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideTransition(
                  position: animation,
                  child: Container(
                    height: 50,
                    width: width,
                    margin: EdgeInsets.only(bottom: 50),
                    child: widget.isAdmin!
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.remove_red_eye, color: Colors.white),
                              SizedBox(),
                              Obx(
                                () => Text(
                                  totalView.value == 10000
                                      ? ''
                                      : '${totalView.value}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.keyboard_arrow_up_rounded,
                                  color: Colors.white),
                              Text(
                                'Reply',
                                style: TextStyle(color: Colors.white54),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future storyPreview(String id) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Container(
            height: 500,
            child: Views(
              userId: id,
            ));
      },
    );
  }

  Future replyPreview(
    String id,
  ) {
    TextEditingController captionController = TextEditingController();
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Container(
            height: height * 0.530,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: height * 0.080,
                    margin: EdgeInsets.only(left: 40, right: 40),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            '${widget.userStories!.username}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent,
                                fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              height: 50,
                              width: 60,
                              child: Image.network(
                                  '${widget.userStories!.stories![currentIndex].thumbnail}',
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: height * 0.070,
                    margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      onSubmitted: (v) {
                        print('done call');
                        Navigator.of(context).pop();
                      },
                      controller: captionController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Add a Caption',
                        hintStyle: TextStyle(color: Colors.greenAccent),
                        prefixIcon: Icon(
                          Icons.image,
                          color: Colors.greenAccent,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              sentMessageWithoutFile(map: {
                                'server_key': serverKey,
                                'text': captionController.text,
                                'user_id': '${widget.userStories!.userId}',
                                'message_hash_id': '44444444',
                                'story_id': widget
                                    .userStories!.stories![currentIndex].id
                              });
                              Navigator.of(context).pop('send');
                            },
                            icon: Icon(
                              Icons.send,
                              color: Colors.greenAccent,
                            )),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
