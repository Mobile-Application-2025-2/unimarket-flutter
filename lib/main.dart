import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniMarket',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFC436), // Color principal
          onPrimary: Colors.white,
          secondary: Color(0xFFF7D547),
          onSecondary: Colors.black,
          tertiary: Color(0xFFFFD27C),
          onTertiary: Colors.black,
          surface: Color(0xFFFFF72),
          onSurface: Colors.black,
          background: Color(0xFFFFF72),
          onBackground: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          outline: Color(0xFFB57C00),
          shadow: Color(0xFFD09306),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFECAB0F),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFC436),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFC436),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFFFFF72),
          elevation: 4,
          shadowColor: const Color(0xFFD09306),
        ),
      ),
      home: const MyHomePage(title: 'UniMarket'),
      debugShowCheckedModeBanner: false,
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
