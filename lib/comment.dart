class Comment {
  late String id;
  late String text;
  late String date;
  late String postId;

  Comment(
      {required this.id,
      required this.text,
      required this.date,
      required this.postId});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    text = json['text'];
    postId = json['postId'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['text'] = this.text;
    data['postId'] = this.postId;
    data['date'] = this.date;
    return data;
  }
}
