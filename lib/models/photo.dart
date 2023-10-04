class Photo {
  final String id;
  final String url;

  Photo({
    required this.id,
    required this.url,
  });

  factory Photo.fromJson(String id, Map<String, dynamic> json) {
    return Photo(
      id: id,
      url: json['url'] as String,
    );
  }
}
