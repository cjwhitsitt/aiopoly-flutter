import 'package:aiopoly/firebase_options.dart';
import 'package:aiopoly/result_route.dart';
import 'package:aiopoly/service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

const String title = 'AIopoly';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    var result = await service.create(controller.text);
    if (result) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const ResultRoute();
      }));
    }
  }
}
