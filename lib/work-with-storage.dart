import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }
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
      home: MyHomePage(title: 'Flutter Demo Home Page', storage: CounterStorage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.storage}) : super(key: key);

  final String title;
  final CounterStorage storage;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter1 = 0;
  int _counter2 = 0;

  @override
  void initState() {
    super.initState();
    getSharedCounter();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter2 = value;
      });
    });
  }

  Future<void> _incrementCounter1() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter1 = (prefs.getInt('counter1') ?? 0) + 1;
    await prefs.setInt('counter1', _counter1);
    setState(() {
      _counter1 = (prefs.getInt('counter1') ?? 0);
    });
  }

  Future<void> getSharedCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter1 = (prefs.getInt('counter1') ?? 0);
    });
  }



  Future<void> _incrementCounter2() {
    setState(() {
      _counter2++;
    });

    return widget.storage.writeCounter(_counter2);
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