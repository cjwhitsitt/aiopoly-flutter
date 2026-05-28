import 'dart:convert';
import 'dart:math';

import 'package:aiopoly/data/player_token.dart';
import 'package:aiopoly/data/property.dart';
import 'package:aiopoly/data/property_group.dart';
import 'package:aiopoly/data/service.dart';
import 'package:aiopoly/ui/property_card_back.dart';
import 'package:aiopoly/ui/property_card_front.dart';
import 'package:aiopoly/ui/token_piece_card.dart';
import 'package:flutter/material.dart';
import 'package:genui/genui.dart';

class ResultRoute extends StatelessWidget {
  final String theme;
  final List<PropertyGroup> propertyGroups;
  final List<PlayerToken> tokens;

  const ResultRoute({
    super.key,
    required this.theme,
    required this.propertyGroups,
    required this.tokens,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (tokens.isNotEmpty) {
      children.addAll([
        Text(
          'Player Tokens',
          style: Theme.of(context)
              .textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: tokens
                .map(
                    (token) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    width: 280,
                    child: TokenPieceCard(token: token),
                  ),
                )).toList(),
          ),
        ),
        const Divider(height: 32, thickness: 1),
      ]);
    }

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
                    child: PropertyCardBack(
                      group: widget.group,
                      property: widget.property,
                    ),
                  )
                : PropertyCardFront(
                    group: widget.group,
                    property: widget.property,
                  ),
          );
        },
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
  late final SurfaceController _controller;
  late final SurfaceContext _surfaceContext;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = SurfaceController(catalogs: [BasicCatalogItems.asCatalog()]);
    _surfaceContext = _controller.contextFor('chance_card');
    _fetchChanceCard();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchChanceCard() async {
    try {
      final service = Service();
      final text = await service.generateChanceCard(widget.theme);
      if (mounted) {
        _controller.handleMessage(
          A2uiMessage.fromJson({
            'version': 'v0.9',
            'createSurface': {
              'surfaceId': 'chance_card',
              'catalogId':
                  'https://a2ui.org/specification/v0_9/basic_catalog.json',
            },
          }),
        );
        _controller.handleMessage(
          A2uiMessage.fromJson(jsonDecode(text) as Map<String, dynamic>),
        );
        setState(() {
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
          : Surface(surfaceContext: _surfaceContext),
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
