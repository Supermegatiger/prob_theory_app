import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            primary: Colors.grey.shade800,
            background: Colors.white,
            shadow: Colors.transparent,
            outline: Colors.transparent),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          background: Colors.grey.shade900,
          surface: Colors.transparent,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Generator'),
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
  var timeDilation=false;
  var globalList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('Определение вероятности'),
                    children: <Widget>[
                      CheckboxListTile(
                        title:
                            const Text('Задача 1'),
                        value: timeDilation,
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = !timeDilation;
                          });
                        },
                      ),
                      CheckboxListTile(
                        title:
                            const Text('Задача 2'),
                        value: timeDilation,
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = !timeDilation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('Теоремы сложения и умножения вероятностей'),
                    children: <Widget>[
                      CheckboxListTile(
                        title:
                            const Text('CheckboxListTile with red background'),
                        value: timeDilation,
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = !timeDilation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('Полная вероятность. Формула Байеса'),
                    children: <Widget>[
                      CheckboxListTile(
                        title:
                            const Text('CheckboxListTile with red background'),
                        value: timeDilation,
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = !timeDilation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('Законы распределения вероятностей дискретных случайных величин'),
                    children: <Widget>[
                      CheckboxListTile(
                        title:
                            const Text('CheckboxListTile with red background'),
                        value: timeDilation,
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = !timeDilation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('Законы распределения вероятностей непрерывных случайных величин'),
                    children: <Widget>[
                      CheckboxListTile(
                        title:
                            const Text('CheckboxListTile with red background'),
                        value: timeDilation,
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = !timeDilation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text('Числовые характеристики случайных величин'),
                    children: <Widget>[
                      CheckboxListTile(
                        title:
                            const Text('CheckboxListTile with red background'),
                        value: timeDilation,
                        onChanged: (bool? value) {
                          setState(() {
                            timeDilation = !timeDilation;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
