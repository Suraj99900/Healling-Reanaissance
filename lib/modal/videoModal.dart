import 'dart:convert';

List<Video> videoFromJson(String str) => List<Video>.from(json.decode(str).map((x) => Video.fromJson(x)));

String videoToJson(List<Video> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Video {
  Video({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.path,
    required this.thumbnail,
    required this.duration,
    required this.addedOn,
    required this.status,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.video_url,
    // required this.category,
  });

  int id;
  int categoryId;
  String title;
  String description;
  String path;
  String thumbnail;
  String video_url;
  String duration;
  DateTime addedOn;
  int status;
  int deleted;
  DateTime createdAt;
  DateTime updatedAt;
  // Category category;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    categoryId: json["category_id"],
    title: json["title"],
    description: json["description"],
    path: json["path"],
    thumbnail: json["thumbnail_url"],
    duration: json["duration"],
    addedOn: DateTime.parse(json["added_on"]),
    status: json["status"],
    deleted: json["deleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    video_url:json["video_url"],
    // category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "title": title,
    "description": description,
    "path": path,
    "thumbnail": thumbnail,
    "duration": duration,
    "added_on": addedOn.toIso8601String(),
    "status": status,
    "deleted": deleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "video_url":video_url,
    // "category": category.toJson(),
  };
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.addedOn,
    required this.status,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.description,
  });

  int id;
  String name;
  DateTime addedOn;
  int status;
  int deleted;
  DateTime createdAt;
  DateTime updatedAt;
  String description;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    addedOn: DateTime.parse(json["added_on"]),
    status: json["status"],
    deleted: json["deleted"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "added_on": addedOn.toIso8601String(),
    "status": status,
    "deleted": deleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "description": description,
  };
}
