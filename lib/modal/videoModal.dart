class Video {
  Video({
    required this.id,
    required this.videoUid,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.path,
    this.cloudflareVideoId,
    this.videoJsonData,
    required this.hlsPath,
    required this.isConvertedHlsVideo,
    required this.thumbnail,
    required this.duration,
    required this.addedOn,
    required this.status,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.hlsUrl,
  });

  int id;
  String videoUid;
  int categoryId;
  String title;
  String description;
  String path;
  String? cloudflareVideoId;
  dynamic videoJsonData;
  String hlsPath;
  int isConvertedHlsVideo;
  String thumbnail;
  String duration;
  DateTime addedOn;
  int status;
  int deleted;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String thumbnailUrl;
  String videoUrl;
  String hlsUrl;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"] ?? 0,
    videoUid: json["video_uid"] ?? '',
    categoryId: json["category_id"] ?? 0,
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    path: json["path"] ?? '',
    cloudflareVideoId: json["cloudflare_video_id"],
    videoJsonData: json["video_json_data"],
    hlsPath: json["hls_path"] ?? '',
    isConvertedHlsVideo: json["is_converted_hls_video"] ?? 0,
    thumbnail: json["thumbnail"] ?? '',
    duration: json["duration"]?.toString() ?? '',
    addedOn: DateTime.parse(json["added_on"] ?? DateTime.now().toIso8601String()),
    status: json["status"] ?? 0,
    deleted: json["deleted"] ?? 0,
    createdAt: DateTime.parse(json["created_at"] ?? DateTime.now().toIso8601String()),
    updatedAt: DateTime.parse(json["updated_at"] ?? DateTime.now().toIso8601String()),
    name: json["name"] ?? '',
    thumbnailUrl: json["thumbnail_url"] ?? '',
    videoUrl: json["video_url"] ?? '',
    hlsUrl: json["hls_url"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video_uid": videoUid,
    "category_id": categoryId,
    "title": title,
    "description": description,
    "path": path,
    "cloudflare_video_id": cloudflareVideoId,
    "video_json_data": videoJsonData,
    "hls_path": hlsPath,
    "is_converted_hls_video": isConvertedHlsVideo,
    "thumbnail": thumbnail,
    "duration": duration,
    "added_on": addedOn.toIso8601String(),
    "status": status,
    "deleted": deleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "name": name,
    "thumbnail_url": thumbnailUrl,
    "video_url": videoUrl,
    "hls_url": hlsUrl,
  };
}