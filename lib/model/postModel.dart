class PostModel {
  String? name;
  String? profileImage;
  String? uID;

  String? text;

  String? postImageSaved;
  String? dateTime;

  PostModel({
    required this.name,
    required this.text,
    required this.postImageSaved,
    required this.profileImage,
    required this.dateTime,
    required this.uID,
  });

  PostModel.fromJson(Map<String, dynamic>? json) {
    name = json!['name'];
    text = json['text'];
    postImageSaved = json['postImageSaved'];
    profileImage = json['profileImage'];
    dateTime = json['dateTime'];
    uID = json['uID'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'text': text,
      'postImageSaved': postImageSaved,
      'profileImage': profileImage,
      'dateTime': dateTime,
      'uID': uID,
    };
  }
}
