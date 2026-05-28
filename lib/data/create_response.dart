import 'package:aiopoly/data/player_token.dart';
import 'package:aiopoly/data/property_group.dart';

class CreateResponse {
  final List<PropertyGroup> groups;
  final List<PlayerToken> tokens;

  CreateResponse({required this.groups, required this.tokens});

  factory CreateResponse.fromJson(Map<String, dynamic> json) {
    var groups = <PropertyGroup>[];
    var tokens = <PlayerToken>[];

    var groupsJson = json['groups'];
    if (groupsJson is List) {
      for (var element in groupsJson) {
        var group = PropertyGroup.fromJson(element);
        groups.add(group);
      }
    }

    var tokensJson = json['tokens'];
    if (tokensJson is List) {
      for (var element in tokensJson) {
        var token = PlayerToken.fromJson(element);
        tokens.add(token);
      }
    }

    return CreateResponse(groups: groups, tokens: tokens);
  }
}
