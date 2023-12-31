import 'package:aiopoly/data/property_group.dart';
import 'package:aiopoly/routes/result_route.dart';
import 'package:aiopoly/data/service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeRoute extends StatefulWidget {
  final String title;

  const HomeRoute({super.key, required this.title});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  final _controller = TextEditingController();
  final _service = Service();

  var _canSubmit = false;
  var _loading = false;

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
                  autofocus: true,
                  controller: _controller,
                  enabled: !_loading,
                  onChanged: (value) => setState(() {
                    _canSubmit = value.isNotEmpty;
                  }),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              const SizedBox(width: 12),
              _loading
                ? const CircularProgressIndicator.adaptive()
                : IconButton(
                  onPressed: _canSubmit ? () => _submit() : null,
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

  void _submit() {
    setState(() {
      _loading = true;
    });
    var theme = _controller.text;

    _service.create(theme).then((value) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ResultRoute(theme: theme, propertyGroups: value);
      }));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}