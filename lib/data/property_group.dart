import 'package:aiopoly/data/property.dart';

class PropertyGroup {
  final String colorName;
  final String colorHex;
  final List<Property> properties;

  PropertyGroup({
    required this.colorName,
    required this.colorHex,
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
      colorName: json['color'],
      colorHex: json['hex'],
      properties: properties,
    );
  }
}