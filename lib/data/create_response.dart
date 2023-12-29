import 'package:aiopoly/data/property_group.dart';

class CreateResponse {
  final List<PropertyGroup> groups;

  CreateResponse({required this.groups});

  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    var groups = <PropertyGroup>[];

    var groupsJson = json['groups'];
    if (groupsJson is List) {
      for (var element in groupsJson) {
        var group = PropertyGroup.fromJson(element);
        groups.add(group);
      }
    }

    return CreateResponse(groups: groups);
  }
}