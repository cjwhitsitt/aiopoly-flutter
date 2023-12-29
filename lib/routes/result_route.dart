import 'package:aiopoly/utils/hex_color.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:flutter/material.dart';

class ResultRoute extends StatelessWidget {
  final String theme;
  final List<PropertyGroup> propertyGroups;

  const ResultRoute({super.key, required this.theme, required this.propertyGroups});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Properties'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemBuilder: _item,
      )
    );
  }

  Widget? _item(BuildContext ctx, int i) {
    if (i == 0) {
      return Center(
        child: Text('Game Theme: $theme'),
      );
    }
    i--;

    if (i < propertyGroups.length) {
      var group = propertyGroups[i];
      return Card(
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 24,
                color: HexColor.fromHex(group.colorHex),
              ),
              const SizedBox(
                width: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: group.properties.map((e) {
                    return Row(
                      children: [
                        Text(e.name),
                        Text(' - ${e.rent.toString()}'),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    i =- propertyGroups.length;

    return null;
  }
}