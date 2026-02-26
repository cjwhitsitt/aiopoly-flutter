class Property {
  final String name;
  final int rent;
  final int mortgageValue;
  final int payoffCost;

  Property({
    required this.name,
    required this.rent,
    required this.mortgageValue,
    required this.payoffCost,
  });

  factory Property.fromJson(Map json) {
    return Property(
      name: json['name'],
      rent: json['rent'],
      mortgageValue: json['mortgageValue'] ?? 0,
      payoffCost: json['payoffCost'] ?? 0,
    );
  }
}
