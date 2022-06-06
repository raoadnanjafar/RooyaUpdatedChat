class UserStoryModel {
  String? userId;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? avatar;
  String? cover;
  String? backgroundImage;
  String? relationshipId;
  String? address;
  String? working;
  String? workingLink;
  String? about;
  String? school;
  String? gender;
  String? birthday;
  String? countryId;
  String? website;
  String? facebook;
  String? google;
  String? twitter;
  String? linkedin;
  String? youtube;
  String? vk;
  String? instagram;
  String? okru;
  String? language;
  String? ipAddress;
  String? followPrivacy;
  String? friendPrivacy;
  String? postPrivacy;
  String? messagePrivacy;
  String? confirmFollowers;
  String? showActivitiesPrivacy;
  String? birthPrivacy;
  String? visitPrivacy;
  String? verified;
  String? lastseen;
  String? emailNotification;
  String? eLiked;
  String? eWondered;
  String? eShared;
  String? eFollowed;
  String? eCommented;
  String? eVisited;
  String? eLikedPage;
  String? eMentioned;
  String? eJoinedGroup;
  String? eAccepted;
  String? eProfileWallPost;
  String? eSentmeMsg;
  String? eLastNotif;
  String? notificationSettings;
  String? status;
  String? active;
  String? admin;
  String? registered;
  String? phoneNumber;
  String? isPro;
  String? proType;
  String? timezone;
  String? referrer;
  String? refUserId;
  String? balance;
  String? paypalEmail;
  String? notificationsSound;
  String? orderPostsBy;
  String? androidMDeviceId;
  String? iosMDeviceId;
  String? androidNDeviceId;
  String? iosNDeviceId;
  String? webDeviceId;
  String? wallet;
  String? lat;
  String? lng;
  String? lastLocationUpdate;
  String? shareMyLocation;
  String? lastDataUpdate;
  Details? details;
  String? lastAvatarMod;
  String? lastCoverMod;
  String? points;
  String? dailyPoints;
  String? pointDayExpire;
  String? lastFollowId;
  String? shareMyData;
  String? twoFactor;
  String? newEmail;
  String? twoFactorVerified;
  String? newPhone;
  String? infoFile;
  String? city;
  String? state;
  String? zip;
  String? schoolCompleted;
  String? weatherUnit;
  String? paystackRef;
  String? codeSent;
  String? timeCodeSent;
  String? currentlyWorking;
  String? banned;
  String? bannedReason;
  String? coinbaseHash;
  String? coinbaseCode;
  String? yoomoneyHash;
  String? conversationId;
  String? securionpayKey;
  String? avatarPostId;
  String? coverPostId;
  String? avatarFull;
  String? userPlatform;
  String? url;
  String? name;
  APINotificationSettings? aPINotificationSettings;
  String? isNotifyStopped;
  String? lastseenUnixTime;
  String? lastseenStatus;
  bool? isReported;
  bool? isStoryMuted;
  String? isFollowingMe;
  String? isOpenToWork;
  String? isProvidingService;
  String? providingService;
  String? openToWorkData;
  List<Stories>? stories;

  UserStoryModel(
      {this.userId,
        this.username,
        this.email,
        this.firstName,
        this.lastName,
        this.avatar,
        this.cover,
        this.backgroundImage,
        this.relationshipId,
        this.address,
        this.working,
        this.workingLink,
        this.about,
        this.school,
        this.gender,
        this.birthday,
        this.countryId,
        this.website,
        this.facebook,
        this.google,
        this.twitter,
        this.linkedin,
        this.youtube,
        this.vk,
        this.instagram,
        this.okru,
        this.language,
        this.ipAddress,
        this.followPrivacy,
        this.friendPrivacy,
        this.postPrivacy,
        this.messagePrivacy,
        this.confirmFollowers,
        this.showActivitiesPrivacy,
        this.birthPrivacy,
        this.visitPrivacy,
        this.verified,
        this.lastseen,
        this.emailNotification,
        this.eLiked,
        this.eWondered,
        this.eShared,
        this.eFollowed,
        this.eCommented,
        this.eVisited,
        this.eLikedPage,
        this.eMentioned,
        this.eJoinedGroup,
        this.eAccepted,
        this.eProfileWallPost,
        this.eSentmeMsg,
        this.eLastNotif,
        this.notificationSettings,
        this.status,
        this.active,
        this.admin,
        this.registered,
        this.phoneNumber,
        this.isPro,
        this.proType,
        this.timezone,
        this.referrer,
        this.refUserId,
        this.balance,
        this.paypalEmail,
        this.notificationsSound,
        this.orderPostsBy,
        this.androidMDeviceId,
        this.iosMDeviceId,
        this.androidNDeviceId,
        this.iosNDeviceId,
        this.webDeviceId,
        this.wallet,
        this.lat,
        this.lng,
        this.lastLocationUpdate,
        this.shareMyLocation,
        this.lastDataUpdate,
        this.details,
        this.lastAvatarMod,
        this.lastCoverMod,
        this.points,
        this.dailyPoints,
        this.pointDayExpire,
        this.lastFollowId,
        this.shareMyData,
        this.twoFactor,
        this.newEmail,
        this.twoFactorVerified,
        this.newPhone,
        this.infoFile,
        this.city,
        this.state,
        this.zip,
        this.schoolCompleted,
        this.weatherUnit,
        this.paystackRef,
        this.codeSent,
        this.timeCodeSent,
        this.currentlyWorking,
        this.banned,
        this.bannedReason,
        this.coinbaseHash,
        this.coinbaseCode,
        this.yoomoneyHash,
        this.conversationId,
        this.securionpayKey,
        this.avatarPostId,
        this.coverPostId,
        this.avatarFull,
        this.userPlatform,
        this.url,
        this.name,
        this.aPINotificationSettings,
        this.isNotifyStopped,
        this.lastseenUnixTime,
        this.lastseenStatus,
        this.isReported,
        this.isStoryMuted,
        this.isFollowingMe,
        this.isOpenToWork,
        this.isProvidingService,
        this.providingService,
        this.openToWorkData,
        this.stories});

  UserStoryModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].toString();
    username = json['username'].toString();
    email = json['email'].toString();
    firstName = json['first_name'].toString();
    lastName = json['last_name'].toString();
    avatar = json['avatar'].toString();
    cover = json['cover'].toString();
    backgroundImage = json['background_image'].toString();
    relationshipId = json['relationship_id'].toString();
    address = json['address'].toString();
    working = json['working'].toString();
    workingLink = json['working_link'].toString();
    about = json['about'].toString();
    school = json['school'].toString();
    gender = json['gender'].toString();
    birthday = json['birthday'].toString();
    countryId = json['country_id'].toString();
    website = json['website'].toString();
    facebook = json['facebook'].toString();
    google = json['google'].toString();
    twitter = json['twitter'].toString();
    linkedin = json['linkedin'].toString();
    youtube = json['youtube'].toString();
    vk = json['vk'].toString();
    instagram = json['instagram'].toString();
    okru = json['okru'].toString();
    language = json['language'].toString();
    ipAddress = json['ip_address'].toString();
    followPrivacy = json['follow_privacy'].toString();
    friendPrivacy = json['friend_privacy'].toString();
    postPrivacy = json['post_privacy'].toString();
    messagePrivacy = json['message_privacy'].toString();
    confirmFollowers = json['confirm_followers'].toString();
    showActivitiesPrivacy = json['show_activities_privacy'].toString();
    birthPrivacy = json['birth_privacy'].toString();
    visitPrivacy = json['visit_privacy'].toString();
    verified = json['verified'].toString();
    lastseen = json['lastseen'].toString();
    emailNotification = json['emailNotification'].toString();
    eLiked = json['e_liked'].toString();
    eWondered = json['e_wondered'].toString();
    eShared = json['e_shared'].toString();
    eFollowed = json['e_followed'].toString();
    eCommented = json['e_commented'].toString();
    eVisited = json['e_visited'].toString();
    eLikedPage = json['e_liked_page'].toString();
    eMentioned = json['e_mentioned'].toString();
    eJoinedGroup = json['e_joined_group'].toString();
    eAccepted = json['e_accepted'].toString();
    eProfileWallPost = json['e_profile_wall_post'].toString();
    eSentmeMsg = json['e_sentme_msg'].toString();
    eLastNotif = json['e_last_notif'].toString();
    notificationSettings = json['notification_settings'].toString();
    status = json['status'].toString();
    active = json['active'].toString();
    admin = json['admin'].toString();
    registered = json['registered'].toString();
    phoneNumber = json['phone_number'].toString();
    isPro = json['is_pro'].toString();
    proType = json['pro_type'].toString();
    timezone = json['timezone'].toString();
    referrer = json['referrer'].toString();
    refUserId = json['ref_user_id'].toString();
    balance = json['balance'].toString();
    paypalEmail = json['paypal_email'].toString();
    notificationsSound = json['notifications_sound'].toString();
    orderPostsBy = json['order_posts_by'].toString();
    androidMDeviceId = json['android_m_device_id'].toString();
    iosMDeviceId = json['ios_m_device_id'].toString();
    androidNDeviceId = json['android_n_device_id'].toString();
    iosNDeviceId = json['ios_n_device_id'].toString();
    webDeviceId = json['web_device_id'].toString();
    wallet = json['wallet'].toString();
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    lastLocationUpdate = json['last_location_update'].toString();
    shareMyLocation = json['share_my_location'].toString();
    lastDataUpdate = json['last_data_update'].toString();
    details =
    json['details'] != null ? new Details.fromJson(json['details']) : null;
    lastAvatarMod = json['last_avatar_mod'].toString();
    lastCoverMod = json['last_cover_mod'].toString();
    points = json['points'].toString();
    dailyPoints = json['daily_points'].toString();
    pointDayExpire = json['point_day_expire'].toString();
    lastFollowId = json['last_follow_id'].toString();
    shareMyData = json['share_my_data'].toString();
    twoFactor = json['two_factor'].toString();
    newEmail = json['new_email'].toString();
    twoFactorVerified = json['two_factor_verified'].toString();
    newPhone = json['new_phone'].toString();
    infoFile = json['info_file'].toString();
    city = json['city'].toString();
    state = json['state'].toString();
    zip = json['zip'].toString();
    schoolCompleted = json['school_completed'].toString();
    weatherUnit = json['weather_unit'].toString();
    paystackRef = json['paystack_ref'].toString();
    codeSent = json['code_sent'].toString();
    timeCodeSent = json['time_code_sent'].toString();
    currentlyWorking = json['currently_working'].toString();
    banned = json['banned'].toString();
    bannedReason = json['banned_reason'].toString();
    coinbaseHash = json['coinbase_hash'].toString();
    coinbaseCode = json['coinbase_code'].toString();
    yoomoneyHash = json['yoomoney_hash'].toString();
    conversationId = json['ConversationId'].toString();
    securionpayKey = json['securionpay_key'].toString();
    avatarPostId = json['avatar_post_id'].toString();
    coverPostId = json['cover_post_id'].toString();
    avatarFull = json['avatar_full'].toString();
    userPlatform = json['user_platform'].toString();
    url = json['url'].toString();
    name = json['name'].toString();
    aPINotificationSettings = json['API_notification_settings'] != null
        ? new APINotificationSettings.fromJson(
        json['API_notification_settings'])
        : null;
    isNotifyStopped = json['is_notify_stopped'].toString();
    lastseenUnixTime = json['lastseen_unix_time'].toString();
    lastseenStatus = json['lastseen_status'].toString();
    isReported = json['is_reported'];
    isStoryMuted = json['is_story_muted'];
    isFollowingMe = json['is_following_me'].toString();
    isOpenToWork = json['is_open_to_work'].toString();
    isProvidingService = json['is_providing_service'].toString();
    providingService = json['providing_service'].toString();
    openToWorkData = json['open_to_work_data'].toString();
    if (json['stories'] != null) {
      stories = <Stories>[];
      json['stories'].forEach((v) {
        stories!.add(new Stories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['avatar'] = this.avatar;
    data['cover'] = this.cover;
    data['background_image'] = this.backgroundImage;
    data['relationship_id'] = this.relationshipId;
    data['address'] = this.address;
    data['working'] = this.working;
    data['working_link'] = this.workingLink;
    data['about'] = this.about;
    data['school'] = this.school;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['country_id'] = this.countryId;
    data['website'] = this.website;
    data['facebook'] = this.facebook;
    data['google'] = this.google;
    data['twitter'] = this.twitter;
    data['linkedin'] = this.linkedin;
    data['youtube'] = this.youtube;
    data['vk'] = this.vk;
    data['instagram'] = this.instagram;
    data['okru'] = this.okru;
    data['language'] = this.language;
    data['ip_address'] = this.ipAddress;
    data['follow_privacy'] = this.followPrivacy;
    data['friend_privacy'] = this.friendPrivacy;
    data['post_privacy'] = this.postPrivacy;
    data['message_privacy'] = this.messagePrivacy;
    data['confirm_followers'] = this.confirmFollowers;
    data['show_activities_privacy'] = this.showActivitiesPrivacy;
    data['birth_privacy'] = this.birthPrivacy;
    data['visit_privacy'] = this.visitPrivacy;
    data['verified'] = this.verified;
    data['lastseen'] = this.lastseen;
    data['emailNotification'] = this.emailNotification;
    data['e_liked'] = this.eLiked;
    data['e_wondered'] = this.eWondered;
    data['e_shared'] = this.eShared;
    data['e_followed'] = this.eFollowed;
    data['e_commented'] = this.eCommented;
    data['e_visited'] = this.eVisited;
    data['e_liked_page'] = this.eLikedPage;
    data['e_mentioned'] = this.eMentioned;
    data['e_joined_group'] = this.eJoinedGroup;
    data['e_accepted'] = this.eAccepted;
    data['e_profile_wall_post'] = this.eProfileWallPost;
    data['e_sentme_msg'] = this.eSentmeMsg;
    data['e_last_notif'] = this.eLastNotif;
    data['notification_settings'] = this.notificationSettings;
    data['status'] = this.status;
    data['active'] = this.active;
    data['admin'] = this.admin;
    data['registered'] = this.registered;
    data['phone_number'] = this.phoneNumber;
    data['is_pro'] = this.isPro;
    data['pro_type'] = this.proType;
    data['timezone'] = this.timezone;
    data['referrer'] = this.referrer;
    data['ref_user_id'] = this.refUserId;
    data['balance'] = this.balance;
    data['paypal_email'] = this.paypalEmail;
    data['notifications_sound'] = this.notificationsSound;
    data['order_posts_by'] = this.orderPostsBy;
    data['android_m_device_id'] = this.androidMDeviceId;
    data['ios_m_device_id'] = this.iosMDeviceId;
    data['android_n_device_id'] = this.androidNDeviceId;
    data['ios_n_device_id'] = this.iosNDeviceId;
    data['web_device_id'] = this.webDeviceId;
    data['wallet'] = this.wallet;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['last_location_update'] = this.lastLocationUpdate;
    data['share_my_location'] = this.shareMyLocation;
    data['last_data_update'] = this.lastDataUpdate;
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    data['last_avatar_mod'] = this.lastAvatarMod;
    data['last_cover_mod'] = this.lastCoverMod;
    data['points'] = this.points;
    data['daily_points'] = this.dailyPoints;
    data['point_day_expire'] = this.pointDayExpire;
    data['last_follow_id'] = this.lastFollowId;
    data['share_my_data'] = this.shareMyData;
    data['two_factor'] = this.twoFactor;
    data['new_email'] = this.newEmail;
    data['two_factor_verified'] = this.twoFactorVerified;
    data['new_phone'] = this.newPhone;
    data['info_file'] = this.infoFile;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['school_completed'] = this.schoolCompleted;
    data['weather_unit'] = this.weatherUnit;
    data['paystack_ref'] = this.paystackRef;
    data['code_sent'] = this.codeSent;
    data['time_code_sent'] = this.timeCodeSent;
    data['currently_working'] = this.currentlyWorking;
    data['banned'] = this.banned;
    data['banned_reason'] = this.bannedReason;
    data['coinbase_hash'] = this.coinbaseHash;
    data['coinbase_code'] = this.coinbaseCode;
    data['yoomoney_hash'] = this.yoomoneyHash;
    data['ConversationId'] = this.conversationId;
    data['securionpay_key'] = this.securionpayKey;
    data['avatar_post_id'] = this.avatarPostId;
    data['cover_post_id'] = this.coverPostId;
    data['avatar_full'] = this.avatarFull;
    data['user_platform'] = this.userPlatform;
    data['url'] = this.url;
    data['name'] = this.name;
    if (this.aPINotificationSettings != null) {
      data['API_notification_settings'] =
          this.aPINotificationSettings!.toJson();
    }
    data['is_notify_stopped'] = this.isNotifyStopped;
    data['lastseen_unix_time'] = this.lastseenUnixTime;
    data['lastseen_status'] = this.lastseenStatus;
    data['is_reported'] = this.isReported;
    data['is_story_muted'] = this.isStoryMuted;
    data['is_following_me'] = this.isFollowingMe;
    data['is_open_to_work'] = this.isOpenToWork;
    data['is_providing_service'] = this.isProvidingService;
    data['providing_service'] = this.providingService;
    data['open_to_work_data'] = this.openToWorkData;
    if (this.stories != null) {
      data['stories'] = this.stories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? postCount;
  String? albumCount;
  String? followingCount;
  String? followersCount;
  String? groupsCount;
  String? likesCount;
  String? mutualFriendsCount;

  Details(
      {this.postCount,
        this.albumCount,
        this.followingCount,
        this.followersCount,
        this.groupsCount,
        this.likesCount,
        this.mutualFriendsCount});

  Details.fromJson(Map<String, dynamic> json) {
    postCount = json['post_count'].toString();
    albumCount = json['album_count'].toString();
    followingCount = json['following_count'].toString();
    followersCount = json['followers_count'].toString();
    groupsCount = json['groups_count'].toString();
    likesCount = json['likes_count'].toString();
    mutualFriendsCount = json['mutual_friends_count'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_count'] = this.postCount;
    data['album_count'] = this.albumCount;
    data['following_count'] = this.followingCount;
    data['followers_count'] = this.followersCount;
    data['groups_count'] = this.groupsCount;
    data['likes_count'] = this.likesCount;
    data['mutual_friends_count'] = this.mutualFriendsCount;
    return data;
  }
}

class APINotificationSettings {
  String? eLiked;
  String? eShared;
  String? eWondered;
  String? eCommented;
  String? eFollowed;
  String? eAccepted;
  String? eMentioned;
  String? eJoinedGroup;
  String? eLikedPage;
  String? eVisited;
  String? eProfileWallPost;
  String? eMemory;

  APINotificationSettings(
      {this.eLiked,
        this.eShared,
        this.eWondered,
        this.eCommented,
        this.eFollowed,
        this.eAccepted,
        this.eMentioned,
        this.eJoinedGroup,
        this.eLikedPage,
        this.eVisited,
        this.eProfileWallPost,
        this.eMemory});

  APINotificationSettings.fromJson(Map<String, dynamic> json) {
    eLiked = json['e_liked'].toString();
    eShared = json['e_shared'].toString();
    eWondered = json['e_wondered'].toString();
    eCommented = json['e_commented'].toString();
    eFollowed = json['e_followed'].toString();
    eAccepted = json['e_accepted'].toString();
    eMentioned = json['e_mentioned'].toString();
    eJoinedGroup = json['e_joined_group'].toString();
    eLikedPage = json['e_liked_page'].toString();
    eVisited = json['e_visited'].toString();
    eProfileWallPost = json['e_profile_wall_post'].toString();
    eMemory = json['e_memory'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['e_liked'] = this.eLiked;
    data['e_shared'] = this.eShared;
    data['e_wondered'] = this.eWondered;
    data['e_commented'] = this.eCommented;
    data['e_followed'] = this.eFollowed;
    data['e_accepted'] = this.eAccepted;
    data['e_mentioned'] = this.eMentioned;
    data['e_joined_group'] = this.eJoinedGroup;
    data['e_liked_page'] = this.eLikedPage;
    data['e_visited'] = this.eVisited;
    data['e_profile_wall_post'] = this.eProfileWallPost;
    data['e_memory'] = this.eMemory;
    return data;
  }
}

class Stories {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? posted;
  String? expire;
  String? thumbnail;
  String? eventId;
  List<Videos>? videos;
  bool? isOwner;
  Reaction? reaction;
  String? isViewed;
  String? timeText;
  String? viewCount;
  List<Null>? images;

  Stories(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.posted,
        this.expire,
        this.thumbnail,
        this.eventId,
        this.videos,
        this.isOwner,
        this.reaction,
        this.isViewed,
        this.timeText,
        this.viewCount,
        this.images});

  Stories.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    title = json['title'].toString();
    description = json['description'].toString();
    posted = json['posted'].toString();
    expire = json['expire'].toString();
    thumbnail = json['thumbnail'].toString();
    eventId = json['event_id'].toString();
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    isOwner = json['is_owner'];
    reaction = json['reaction'] != null
        ? new Reaction.fromJson(json['reaction'])
        : null;
    isViewed = json['is_viewed'].toString();
    timeText = json['time_text'].toString();
    viewCount = json['view_count'].toString();
    // if (json['images'] != null) {
    //   images = <Null>[];
    //   json['images'].forEach((v) {
    //     images!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['posted'] = this.posted;
    data['expire'] = this.expire;
    data['thumbnail'] = this.thumbnail;
    data['event_id'] = this.eventId;
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    data['is_owner'] = this.isOwner;
    if (this.reaction != null) {
      data['reaction'] = this.reaction!.toJson();
    }
    data['is_viewed'] = this.isViewed;
    data['time_text'] = this.timeText;
    data['view_count'] = this.viewCount;
    // if (this.images != null) {
    //   data['images'] = this.images!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Videos {
  String? id;
  String? storyId;
  String? type;
  String? filename;
  String? expire;

  Videos({this.id, this.storyId, this.type, this.filename, this.expire});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    storyId = json['story_id'].toString();
    type = json['type'].toString();
    filename = json['filename'].toString();
    expire = json['expire'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['story_id'] = this.storyId;
    data['type'] = this.type;
    data['filename'] = this.filename;
    data['expire'] = this.expire;
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