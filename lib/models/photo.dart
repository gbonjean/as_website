class Photo {
  final String id;
  final String url;
  final String? lead;

  Photo({
    required this.id,
    required this.url,
    this.lead,
  });

  factory Photo.fromJson(String id, Map<String, dynamic> json) {
    return Photo(
      id: id,
      url: json['url'] as String,
    );
  }

  factory Photo.fromJsonWithLead(String id, Map<String, dynamic> json) {
    return Photo(
      id: id,
      url: json['url'] as String,
      lead: json['lead'] as String,
    );
  }
}
