class Property {
  final String name;
  final int rent;

  Property({required this.name, required this.rent});

  factory Property.fromJson(Map json) {
    return Property(
      name: json['name'],
      rent: json['rent'],
    );
  }
}