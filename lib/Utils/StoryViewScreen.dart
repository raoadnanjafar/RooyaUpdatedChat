import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import '../Models/UserStoriesModel.dart';

class StoryScreenUpdated extends StatefulWidget {
  final UserStoryModel? indexStory ;
  final String? userIdStory;
   StoryScreenUpdated({Key? key, this.indexStory, this.userIdStory}) : super(key: key);

  @override
  _StoryScreenUpdatedState createState() => _StoryScreenUpdatedState();
}

class _StoryScreenUpdatedState extends State<StoryScreenUpdated> {
  UserStoryModel? indexStorys ;
  PageController pageController = PageController(initialPage: 0, keepPage: false);
  final StoryController controller = StoryController();
  @override
  void initState() {
    indexStorys = widget.indexStory;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: indexStorys!.stories!.length,
        controller: pageController,
        onPageChanged: (v){

        },
        itemBuilder: (context, index) => Container(
        child: StoryView(
          controller: controller,
          currentIndex: (int c) {
          },
          storyItems: indexStorys!.stories!.map((e) {
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
      ),),
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget? page;
  final String? pageName;

  SlideRightRoute({this.page, this.pageName})
      : super(
      pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          ) =>
      page!,
      transitionDuration: Duration(milliseconds: 300),
      transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
          ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      });
}