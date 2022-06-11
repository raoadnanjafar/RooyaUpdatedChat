import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/ApiConfig/SizeConfiq.dart';
import 'package:rooya/Models/UserStoriesModel.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:video_player/video_player.dart';

class StoryViewPage extends StatefulWidget {
  final UserStoryModel? userStories;
  final bool? isAdmin;

  const StoryViewPage({Key? key, this.userStories, this.isAdmin = false})
      : super(key: key);

  @override
  _StoryViewPageState createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  final StoryController controller = StoryController();

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
                    );
                  }
                }).toList(),
                onStoryShow: (s) {
                  print("Showing a story");
                },
                onComplete: () {
                  print("Completed a cycle");
                },
                progressPosition: ProgressPosition.top,
                repeat: false,
                inline: true,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
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
            )
          ],
        ),
      ),
    );
  }
}
