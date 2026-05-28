import 'package:flutter/material.dart';

import 'package:aiopoly/data/property.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:aiopoly/ui/property_card_front.dart';
import 'package:aiopoly/utils/hex_color.dart';

class PropertyCardBack extends StatelessWidget {
  final PropertyGroup group;
  final Property property;

  const PropertyCardBack({
    super.key,
    required this.group,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final type = group.groupType;
    final theme = Theme.of(context);
    final Color backgroundColor;
    final Color textColor;
    Widget? backIcon;

    if (type == 'railroad') {
      backgroundColor = theme.colorScheme.secondary;
      textColor = theme.colorScheme.onSecondary;
      backIcon = Icon(
        Icons.directions_railway_filled,
        size: 24,
        color: textColor.withValues(alpha: 0.8),
      );
    } else if (type == 'utility') {
      backgroundColor = theme.colorScheme.tertiary;
      textColor = theme.colorScheme.onTertiary;
      backIcon = Icon(
        PropertyCardFront.getUtilityIcon(property.name),
        size: 24,
        color: textColor.withValues(alpha: 0.8),
      );
    } else {
      final colorHex = group.colorHex ?? '#808080';
      backgroundColor = HexColor.fromHex(colorHex);
      textColor = backgroundColor.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      color: backgroundColor,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (backIcon != null) ...[
                    backIcon,
                    const SizedBox(width: 12),
                  ],
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mortgage: \$${property.mortgageValue}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Payoff: \$${property.payoffCost}',
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                Icons.flip,
                size: 16,
                color: textColor.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
