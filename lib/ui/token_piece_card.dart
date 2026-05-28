import 'package:flutter/material.dart';

import 'package:aiopoly/data/player_token.dart';

class TokenPieceCard extends StatelessWidget {
  final PlayerToken token;

  const TokenPieceCard({super.key, required this.token});

  static IconData getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'rocket':
      case 'rocket_launch':
        return Icons.rocket_launch;
      case 'anchor':
        return Icons.anchor;
      case 'pets':
      case 'dog':
      case 'cat':
        return Icons.pets;
      case 'directions_car':
      case 'car':
        return Icons.directions_car;
      case 'sailing':
      case 'boat':
      case 'ship':
        return Icons.sailing;
      case 'flight':
      case 'airplane':
      case 'plane':
        return Icons.flight;
      case 'local_pizza':
      case 'pizza':
        return Icons.local_pizza;
      case 'support':
        return Icons.support;
      case 'crown':
        return Icons.emoji_events;
      case 'star':
        return Icons.star;
      case 'shield':
        return Icons.shield;
      case 'key':
        return Icons.key;
      case 'face':
        return Icons.face;
      case 'work':
      case 'briefcase':
        return Icons.work;
      default:
        return Icons.token;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = getIconData(token.iconName);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Token Icon Container with dynamic backdrop matching color scheme
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 28,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    token.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    token.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
