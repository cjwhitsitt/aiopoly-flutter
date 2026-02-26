import 'package:aiopoly/utils/hex_color.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:aiopoly/data/property.dart';
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
      body: ListView(padding: const EdgeInsets.all(12), children: children),
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
          final angle = _controller.value * 3.1415926535897932;
          final isBackVisible = angle > 3.1415926535897932 / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isBackVisible
                ? Transform(
                    transform: Matrix4.identity()..rotateY(3.1415926535897932),
                    alignment: Alignment.center,
                    child: _buildBack(),
                  )
                : _buildFront(),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 16,
              color: HexColor.fromHex(widget.group.colorHex),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.property.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
    final backgroundColor = HexColor.fromHex(widget.group.colorHex);
    final textColor = backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return Card(
      clipBehavior: Clip.hardEdge,
      color: backgroundColor,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    style: TextStyle(color: textColor.withAlpha(200)),
                  ),
                ],
              ),
              Icon(Icons.flip, size: 16, color: textColor.withAlpha(150)),
            ],
          ),
        ),
      ),
    );
  }
}
