import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rooya/Utils/text_filed/app_font.dart';

import '../GlobalWidget/FileUploader.dart';
import '../Screens/Information/GroupInformation/GroupInformationProvider.dart';
import '../Screens/chat_screen.dart';
import 'StoryViewsModel.dart';

class Views extends StatefulWidget {
  String? userId;

  Views({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ViewsState createState() => _ViewsState();
}

class _ViewsState extends State<Views> {
  var storyViewController = StoryInformationConntroller();

  @override
  void initState() {
    storyViewController.getStoryList(widget.userId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => !storyViewController.loadData.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                      'Views ${storyViewController.listofStory.value.users!.length}',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: AppFonts.segoeui,
                          fontWeight: FontWeight.bold)),
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          storyViewController.listofStory.value.users!.length,
                      itemBuilder: (context, index) => ListTile(
                        leading: CircularProfileAvatar(
                          '',
                          radius: 25,
                          child: CachedNetworkImage(
                            imageUrl:
                                '${storyViewController.listofStory.value.users![index].avatar}',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                            '${storyViewController.listofStory.value.users![index].firstName}'
                                    .isEmpty
                                ? '${storyViewController.listofStory.value.users![index].username}'
                                : '${storyViewController.listofStory.value.users![index].firstName} ' +
                                    '${storyViewController.listofStory.value.users![index].lastName}',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: AppFonts.segoeui,
                            )),
                        trailing: Text('${storyViewController.listofStory.value.users![index].storySeenTime}'),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
