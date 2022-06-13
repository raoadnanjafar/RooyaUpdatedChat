import 'dart:math';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/Models/UserStoriesModel.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';

import '../ApiConfig/BaseURL.dart';
import '../GlobalWidget/FileUploader.dart';
import '../Models/StoryView.dart';
import '../Models/UserChatModel.dart';
import '../Providers/ClickController/SelectIndexController.dart';
import '../Screens/Information/GroupInformation/GroupInformationProvider.dart';

class StoryViewPage extends StatefulWidget {
  final UserStoryModel? userStories;
  final bool? isAdmin;

  const StoryViewPage({
    Key? key,
    this.userStories,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  _StoryViewPageState createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  final StoryController controller = StoryController();
  bool? storyLoaded;
  int currentIndex = 0;
  @override
  void initState() {
    ApiUtils.storyView(mapData: {
      'server_key': serverKey,
      'story_id': '${widget.userStories!.stories![currentIndex].id.toString()}'
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).pop();
      },
      direction: DismissiblePageDismissDirection.multi,
      isFullScreen: false,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: height,
              width: width,
              child: StoryView(
                controller: controller,
                currentIndex: (int c) {
                  print('$c');
                  currentIndex = c + 1;
                  ApiUtils.storyView(mapData: {
                    'server_key': serverKey,
                    'story_id':
                        '${widget.userStories!.stories![currentIndex].id.toString()}'
                  });
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
                  print("Completed a cycle");
                  Navigator.pop(context);
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                inline: true,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
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
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, right: 10),
                child: Visibility(
                  visible: widget.isAdmin == true ? true : false,
                  child: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (storyLoaded = true) {
                        controller.pause();
                        storyPreview(widget
                                .userStories!.stories![currentIndex].id
                                .toString())
                            .then((value) {
                          controller.play();
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future storyPreview(String id) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 500,
            color: Colors.greenAccent,
            child: Views(
              userId: id,
            ));
      },
    );
  }
}
