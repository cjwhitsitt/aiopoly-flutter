import 'package:flutter/material.dart';

class ResultRoute extends StatelessWidget {
  const ResultRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Game'),
      ),
      body: const Center(
        child: Text('Success'),
      ),
    );
  }
}