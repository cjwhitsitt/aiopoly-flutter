class PlayerToken {
  final String name;
  final String description;
  final String iconName;

  PlayerToken({
    required this.name,
    required this.description,
    required this.iconName,
  });

  factory PlayerToken.fromJson(Map json) {
    return PlayerToken(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconName: json['iconName'] ?? '',
    );
  }
}
