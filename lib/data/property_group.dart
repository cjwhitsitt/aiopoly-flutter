import 'package:aiopoly/data/property.dart';

class PropertyGroup {
  final String groupType;
  final String? colorName;
  final String? colorHex;
  final List<Property> properties;

  PropertyGroup({
    required this.groupType,
    this.colorName,
    this.colorHex,
    required this.properties,
  });

  factory PropertyGroup.fromJson(Map json) {
    var properties = <Property>[];
    var propertiesJson = json['properties'];
    if (propertiesJson is List) {
      for (var element in propertiesJson) {
        var property = Property.fromJson(element);
        properties.add(property);
      }
    }

    return PropertyGroup(
      groupType: json['type'] ?? 'color',
      colorName: json['color'],
      colorHex: json['hex'],
      properties: properties,
    );
  }
}
