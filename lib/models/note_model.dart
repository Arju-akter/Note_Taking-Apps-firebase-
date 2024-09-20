class NoteModel {
  String id;
  String? title;
  String? text;

  NoteModel({required this.id, this.title, this.text});
  NoteModel.fromfirebase(Map<String, dynamic> json, this.id) {
    id = id;
    title = json["title"];
    text = json["text"];
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "text": text,
    };
  }

  static fromJson(Map<String, dynamic> data, String id) {}
}
