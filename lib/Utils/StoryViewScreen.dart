import 'package:flutter/material.dart';
import 'package:rooya/ApiConfig/ApiUtils.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import '../Models/UserStoriesModel.dart';
import 'StoryViewPage.dart';

class StoryScreenUpdated extends StatefulWidget {
  final List<UserStoryModel>? storyList;
  final int? currentIndex;
  StoryScreenUpdated({Key? key, this.storyList, this.currentIndex})
      : super(key: key);

  @override
  _StoryScreenUpdatedState createState() => _StoryScreenUpdatedState();
}

class _StoryScreenUpdatedState extends State<StoryScreenUpdated> {
  PageController? pageController;
  final StoryController controller = StoryController();
  @override
  void initState() {
    pageController = PageController(initialPage: widget.currentIndex!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
          itemCount: widget.storyList!.length,
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return StoryViewPage(
              userStories: widget.storyList![index],
              isAdmin:
                  widget.storyList![index].userId == storage.read('userID'),
              swipCallBack: (v) {
                if (v == 'next') {
                  if (index + 1 < widget.storyList!.length) {
                    pageController!.animateToPage(index + 1,
                        duration: Duration(seconds: 1), curve: Curves.ease);
                  } else {
                    Navigator.of(context).pop();
                  }
                } else {
                  if (index >= 1) {
                    pageController!.previousPage(
                        duration: Duration(seconds: 1), curve: Curves.ease);
                  }
                }
              },
            );
          },
          scrollDirection: Axis.horizontal),
    );
  }
}
