import 'package:aiopoly/data/property.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:aiopoly/utils/hex_color.dart';
import 'package:flutter/material.dart';

class PropertyCardFront extends StatelessWidget {
  final PropertyGroup group;
  final Property property;

  const PropertyCardFront({
    super.key,
    required this.group,
    required this.property,
  });

  static IconData getUtilityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('water') ||
        lower.contains('aqueduct') ||
        lower.contains('fluid') ||
        lower.contains('h2o')) {
      return Icons.water_drop;
    }
    if (lower.contains('electric') ||
        lower.contains('power') ||
        lower.contains('light') ||
        lower.contains('energy') ||
        lower.contains('bolt') ||
        lower.contains('voltage')) {
      return Icons.bolt;
    }
    if (lower.contains('internet') ||
        lower.contains('wifi') ||
        lower.contains('network') ||
        lower.contains('data') ||
        lower.contains('web')) {
      return Icons.wifi;
    }
    if (lower.contains('gas') ||
        lower.contains('fuel') ||
        lower.contains('heat') ||
        lower.contains('fire')) {
      return Icons.local_fire_department;
    }
    return Icons.build;
  }

  @override
  Widget build(BuildContext context) {
    final type = group.groupType;
    final theme = Theme.of(context);
    Widget leadingWidget;

    if (type == 'railroad') {
      leadingWidget = Container(
        width: 56,
        color: theme.colorScheme.secondaryContainer,
        child: Center(
          child: Icon(
            Icons.directions_railway_filled,
            color: theme.colorScheme.onSecondaryContainer,
            size: 28,
          ),
        ),
      );
    } else if (type == 'utility') {
      final icon = getUtilityIcon(property.name);
      leadingWidget = Container(
        width: 56,
        color: theme.colorScheme.tertiaryContainer,
        child: Center(
          child: Icon(
            icon,
            color: theme.colorScheme.onTertiaryContainer,
            size: 28,
          ),
        ),
      );
    } else {
      final colorHex = group.colorHex ?? '#808080';
      leadingWidget = Container(width: 16, color: HexColor.fromHex(colorHex));
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        property.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          'Rent: \$${property.rent}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.flip, size: 16, color: Colors.grey[400]),
                        const SizedBox(width: 16),
                      ],
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
