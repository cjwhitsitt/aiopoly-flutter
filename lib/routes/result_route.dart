import 'package:aiopoly/utils/hex_color.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:aiopoly/data/property.dart';
import 'package:flutter/material.dart';

class ResultRoute extends StatelessWidget {
  final String theme;
  final List<PropertyGroup> propertyGroups;

  const ResultRoute({super.key, required this.theme, required this.propertyGroups});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    
    // Header
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            'Game Theme: $theme',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );

    for (var i = 0; i < propertyGroups.length; i++) {
      var group = propertyGroups[i];
      
      // Add a divider between groups
      if (i > 0) {
        children.add(const Divider(height: 32, thickness: 1));
      }

      // Add a card for each property in the group
      for (var property in group.properties) {
        children.add(_propertyCard(group, property));
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Properties'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: children,
      ),
    );
  }

  Widget _propertyCard(PropertyGroup group, Property property) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 16,
              color: HexColor.fromHex(group.colorHex),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      property.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        'Rent: \$${property.rent}',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
