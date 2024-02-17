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
            const Spacer(flex: 2),
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
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
            const Spacer(),
            if (_loading) _row([const CircularProgressIndicator.adaptive()]),
            if (!_loading) _row([
              const Text('Choose how to submit'),
            ]),
            if (!_loading) _row([
              const Spacer(),
              TextButton(
                onPressed: _canSubmit ? () => _submit(ServiceEndpoint.firebase) : null,
                child: const Text('Via Firebase'),
              ),
              const Spacer(),
              TextButton(
                onPressed: _canSubmit ? () => _submit(ServiceEndpoint.direct) : null,
                child: const Text('Direct to Vertex AI'),
              ),
              const Spacer(),
            ]),
            const Spacer(flex: 2),
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

  void _submit(ServiceEndpoint endpoint) {
    setState(() {
      _loading = true;
    });
    var theme = _controller.text;

    _service.create(theme, endpoint: endpoint).then((value) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ResultRoute(theme: theme, propertyGroups: value);
      }));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
      }
      showAdaptiveDialog(context: context, builder: (context) {
        return AlertDialog.adaptive(
          title: const Text('Error'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      });
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
  }
}