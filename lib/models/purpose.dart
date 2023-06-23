/* Tushar Ugale * Technicul.com */
class Purpose {
  final int id;
  final String name;
  final String status;

  Purpose({required this.id, required this.name, required this.status});

  factory Purpose.fromJson(Map<String, dynamic> json) {
    return Purpose(id: json['id'], name: json['name'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
