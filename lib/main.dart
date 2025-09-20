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
        textTheme: TextTheme(
          bodyLarge: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'Poppins'),
          bodyMedium: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'Poppins'),
          bodySmall: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black, fontFamily: 'Poppins'),
          headlineLarge: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
          headlineMedium: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
          headlineSmall: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins'),
          titleLarge: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Poppins'),
          titleMedium: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Poppins'),
          titleSmall: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.black, fontFamily: 'Poppins'),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFFC436), // Color principal
          onPrimary: Colors.white,
          secondary: Color(0xFFF7D547),
          tertiary: Color(0xFFFFD27C),
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
        )
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
            Text('You have pushed the button this many times:', style: Theme.of(context).textTheme.bodyMedium),
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
