import 'package:aiopoly/routes/result_route.dart';
import 'package:aiopoly/data/service.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key, required this.title});

  final String title;

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final controller = TextEditingController();
  final service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _row([
              const Text(
                'Enter a theme for your game',
              ),
            ]),
            _row([
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => _submit(),
                ),
              ),
              IconButton(
                onPressed: () => _submit(),
                icon: const Icon(Icons.arrow_forward),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  void _submit() async {
    var theme = controller.text;
    var result = await service.create(theme);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ResultRoute(theme: theme, propertyGroups: result);
    }));
  }
}