class blockedModel {
  int? apiStatus;
  List<blockedModel>? blockedUsers = [];

  blockedModel({this.apiStatus, this.blockedUsers});
  blockedModel.fromJson(Map<String, dynamic> json) {
    apiStatus = json['api_status'];
    if (json['blocked_users'] != null) {
      blockedUsers = <blockedModel>[];
      json['blocked_users'].forEach((v) {
        blockedUsers!.add(new blockedModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_status'] = this.apiStatus;
    if (this.blockedUsers != null) {
      data['blocked_users'] =
          this.blockedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}