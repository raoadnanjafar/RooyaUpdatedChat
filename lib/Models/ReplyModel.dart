class ReplyModel {
  String? id;
  String? fromId;
  String? groupId;
  String? pageId;
  String? toId;
  String? text;
  String? media;
  String? mediaFileName;
  String? mediaFileNames;
  String? time;
  String? seen;
  String? deletedOne;
  String? deletedTwo;
  String? sentPush;
  String? notificationId;
  String? typeTwo;
  String? stickers;
  String? productId;
  String? lat;
  String? lng;
  String? replyId;
  String? storyId;
  String? broadcastId;
  String? forward;
  String? listening;
  String? delivered;
  MessageUser? messageUser;
  String? orText;
  int? onwer;
  Reaction? reaction;
  String? pin;
  String? fav;
  String? timeText;
  String? position;
  String? thumb;
  String? type;

  ReplyModel(
      {this.id,
        this.thumb,
      this.fromId,
      this.groupId,
      this.pageId,
      this.toId,
      this.text,
      this.media,
      this.mediaFileName,
      this.mediaFileNames,
      this.time,
      this.seen,
      this.deletedOne,
      this.deletedTwo,
      this.sentPush,
      this.notificationId,
      this.typeTwo,
      this.stickers,
      this.productId,
      this.lat,
      this.lng,
      this.replyId,
      this.storyId,
      this.broadcastId,
      this.forward,
      this.listening,
      this.delivered,
      this.messageUser,
      this.orText,
      this.onwer,
      this.reaction,
      this.pin,
      this.fav,
      this.timeText,
      this.position,
      this.type,
      });

  ReplyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    thumb = json['videoThumb'].toString();
    fromId = json['from_id'].toString();
    groupId = json['group_id'].toString();
    pageId = json['page_id'].toString();
    toId = json['to_id'].toString();
    text = json['text'].toString();
    media = json['media'].toString();
    mediaFileName = json['mediaFileName'].toString();
    mediaFileNames = json['mediaFileNames'].toString();
    time = json['time'].toString();
    seen = json['seen'].toString();
    deletedOne = json['deleted_one'].toString();
    deletedTwo = json['deleted_two'].toString();
    sentPush = json['sent_push'].toString();
    notificationId = json['notification_id'].toString();
    typeTwo = json['type_two'].toString();
    stickers = json['stickers'].toString();
    productId = json['product_id'].toString();
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    replyId = json['reply_id'].toString();
    storyId = json['story_id'].toString();
    broadcastId = json['broadcast_id'].toString();
    forward = json['forward'].toString();
    listening = json['listening'].toString();
    delivered = json['delivered'].toString();
    messageUser = json['messageUser'] != null
        ? new MessageUser.fromJson(json['messageUser'])
        : null;
    orText = json['or_text'].toString();
    onwer = json['onwer'];
    // reaction = json['reaction'] != null
    //     ? new Reaction.fromJson(json['reaction'])
    //     : null;
    pin = json['pin'].toString();
    fav = json['fav'].toString();
    timeText = json['time_text'].toString();
    position = json['position'].toString();
    type = json['type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['videoThumb'] = this.thumb;
    data['from_id'] = this.fromId;
    data['group_id'] = this.groupId;
    data['page_id'] = this.pageId;
    data['to_id'] = this.toId;
    data['text'] = this.text;
    data['media'] = this.media;
    data['mediaFileName'] = this.mediaFileName;
    data['mediaFileNames'] = this.mediaFileNames;
    data['time'] = this.time;
    data['seen'] = this.seen;
    data['deleted_one'] = this.deletedOne;
    data['deleted_two'] = this.deletedTwo;
    data['sent_push'] = this.sentPush;
    data['notification_id'] = this.notificationId;
    data['type_two'] = this.typeTwo;
    data['stickers'] = this.stickers;
    data['product_id'] = this.productId;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['reply_id'] = this.replyId;
    data['story_id'] = this.storyId;
    data['broadcast_id'] = this.broadcastId;
    data['forward'] = this.forward;
    data['listening'] = this.listening;
    data['delivered'] = this.delivered;
    if (this.messageUser != null) {
      data['messageUser'] = this.messageUser!.toJson();
    }
    data['or_text'] = this.orText;
    data['onwer'] = this.onwer;
    // if (this.reaction != null) {
    //   data['reaction'] = this.reaction!.toJson();
    // }
    data['pin'] = this.pin;
    data['fav'] = this.fav;
    data['time_text'] = this.timeText;
    data['position'] = this.position;
    data['type'] = this.type;
    return data;
  }
}

class MessageUser {
  String? userId;
  String? avatar;

  MessageUser({this.userId, this.avatar});

  MessageUser.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].toString();
    avatar = json['avatar'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['avatar'] = this.avatar;
    return data;
  }
}

class Reaction {
  bool? isReacted;
  String? type;
  String? count;

  Reaction({this.isReacted, this.type, this.count});

  Reaction.fromJson(Map<String, dynamic> json) {
    isReacted = json['is_reacted'];
    type = json['type'].toString();
    count = json['count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_reacted'] = this.isReacted;
    data['type'] = this.type;
    data['count'] = this.count;
    return data;
  }
}
