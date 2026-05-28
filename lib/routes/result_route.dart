import 'dart:math';

import 'package:aiopoly/utils/hex_color.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:aiopoly/data/property.dart';
import 'package:aiopoly/data/service.dart';
import 'package:flutter/material.dart';

class ResultRoute extends StatelessWidget {
  final String theme;
  final List<PropertyGroup> propertyGroups;

  const ResultRoute({
    super.key,
    required this.theme,
    required this.propertyGroups,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

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
        title: Text('Theme: $theme'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: 100,
        ),
        children: children,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _ChanceCardDialog(theme: theme),
          );
        },
        icon: const Icon(Icons.casino),
        label: const Text('Chance'),
      ),
    );
  }

  Widget _propertyCard(PropertyGroup group, Property property) {
    return PropertyCard(group: group, property: property);
  }
}

class PropertyCard extends StatefulWidget {
  final PropertyGroup group;
  final Property property;

  const PropertyCard({super.key, required this.group, required this.property});

  @override
  State<PropertyCard> createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * pi;
          final isBackVisible = angle > pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isBackVisible
                ? Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildBack(),
                  )
                : _buildFront(),
          );
        },
      ),
    );
  }

  IconData _getUtilityIcon(String name) {
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

  Widget _buildFront() {
    final type = widget.group.groupType;
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
      final icon = _getUtilityIcon(widget.property.name);
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
      final colorHex = widget.group.colorHex ?? '#808080';
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
                        widget.property.name,
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
                          'Rent: \$${widget.property.rent}',
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

  Widget _buildBack() {
    final type = widget.group.groupType;
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
        _getUtilityIcon(widget.property.name),
        size: 24,
        color: textColor.withValues(alpha: 0.8),
      );
    } else {
      final colorHex = widget.group.colorHex ?? '#808080';
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
                        'Mortgage: \$${widget.property.mortgageValue}',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Payoff: \$${widget.property.payoffCost}',
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

class _ChanceCardDialog extends StatefulWidget {
  final String theme;

  const _ChanceCardDialog({required this.theme});

  @override
  State<_ChanceCardDialog> createState() => _ChanceCardDialogState();
}

class _ChanceCardDialogState extends State<_ChanceCardDialog> {
  String? _chanceCardText;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchChanceCard();
  }

  Future<void> _fetchChanceCard() async {
    try {
      final service = Service();
      final text = await service.generateChanceCard(widget.theme);
      if (mounted) {
        setState(() {
          _chanceCardText = text;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.casino, color: Colors.deepPurple),
          const SizedBox(width: 8),
          const Text('Chance'),
        ],
      ),
      content: _loading
          ? const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator.adaptive(),
                SizedBox(height: 16),
                Text('Drawing a card...'),
              ],
            )
          : _error != null
          ? Text('Error: $_error')
          : Text(_chanceCardText ?? '', style: const TextStyle(fontSize: 16)),
      actions: [
        if (!_loading)
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
