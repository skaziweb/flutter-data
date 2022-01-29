import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter1 = 0;
  int _counter2 = 0;

  Future<void> _incrementCounter1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter1 = (prefs.getInt('counter1') ?? 0) + 1;
    await prefs.setInt('counter1', _counter1);
    setState(() {
      _counter1 = (prefs.getInt('counter1') ?? 0);
    });
  }

  Future<void> _incrementCounter2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter2 = (prefs.getInt('counter2') ?? 0) + 1;
    await prefs.setInt('counter2', _counter2);
    setState(() {
      _counter2 = (prefs.getInt('counter2') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Счетчик номер 1 = $_counter1',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Счетчик номер 2 = $_counter2',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              'Количесво нажатий на оба счетчика = ${_counter1 + _counter2}',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
                onPressed: _incrementCounter1,
                child: Text('Счетчик 1')
            ),
            ElevatedButton(
                onPressed: _incrementCounter2,
                child: Text('Счетчик 2')
            )
          ],
        ),
      ),
    );
  }
}
