/* Tushar Ugale * Technicul.com */
class MiniBanner {
  final int id;
  final int index;
  final String image;
  final String link;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String imagePath;
  final String routeKey;

  MiniBanner(
      {required this.id,
      required this.index,
      required this.image,
      required this.link,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.imagePath,
      required this.routeKey});

  factory MiniBanner.fromJson(Map<String, dynamic> json) {
    return MiniBanner(
        id: json['id'],
        index: json['index'],
        image: json['image'],
        link: json['link'],
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        imagePath: json['image_path'],
        routeKey: json['route_key']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['index'] = this.index;
    data['image'] = this.image;
    data['link'] = this.link;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_path'] = this.imagePath;
    data['route_key'] = this.routeKey;
    return data;
  }
}
