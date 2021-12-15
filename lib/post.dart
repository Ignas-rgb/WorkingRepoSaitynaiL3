class Post {
  late String id;
  late String text;
  late String owner;
  late String? date;
  late int v;
  //late String owner;

  Post(
      {required this.id,
      required this.text,
      this.date,
      required this.v,
      required this.owner});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    text = json['text'];
    owner = json['owner'];
    date = json['date'];
    v = json['__v'];

    ///owner = json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['text'] = this.text;
    data['owner'] = this.owner;
    data['date'] = this.date;
    data['__v'] = this.v;

    ///data['owner'] = this.owner;
    return data;
  }
}
