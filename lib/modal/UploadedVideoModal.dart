class UploadedVideoModal {
  final int id;
  final String title;
  final String description;
  final int categoryId;
  final String thumbnail;
  final String categoryName;
  final String uploadDate;

  UploadedVideoModal({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.uploadDate,
    required this.categoryName,
    required this.categoryId,
  });
}
