import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prob_theory_app/options.dart';
import 'dart:convert';

import 'package:prob_theory_app/pages/pdfexport/pdfpreview.dart';

class ParamsPage extends StatefulWidget {
  const ParamsPage({super.key, required this.title});

  final String title;

  @override
  State<ParamsPage> createState() => _ParamsPageState();
}

class _ParamsPageState extends State<ParamsPage> {
  var checkMap = {};
  List _items = [];
  double theoryTasks = 0;
  double variantsCount = 3;
  // Fetch content from the json file
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/data/data.json');
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
      for (var i = 0; i < _items.length; i++) {
        checkMap[i] = {};
        checkMap[i]['all'] = true;
        for (var j = 0; j < _items[i]['tasks'].length; j++) {
          checkMap[i][j] = true;
        }
      }
    });
  }

  void checkTheme(int i) {
    setState(() {
      if (checkMap[i]['all']) {
        for (var j = 0; j < _items[i]['tasks'].length; j++) {
          checkMap[i][j] = true;
        }
      } else {
        for (var j = 0; j < _items[i]['tasks'].length; j++) {
          checkMap[i][j] = false;
        }
      }
    });
  }

  void checkTask(int i) {
    bool flag = true;
    for (var j = 0; j < _items[i]['tasks'].length; j++) {
      if (!checkMap[i][j]) flag = false;
    }
    setState(() {
      checkMap[i]['all'] = flag;
    });
  }

  void setValue(bool value) {
    setState(() {
      for (var i = 0; i < _items.length; i++) {
        checkMap[i]['all'] = value;
        for (var j = 0; j < _items[i]['tasks'].length; j++) {
          checkMap[i][j] = value;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Call the readJson method when the app starts
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          actions: [
            PopupMenuButton(
                padding: EdgeInsets.all(10),
                tooltip: '',
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Выбрать все"),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Text("Снять выделение"),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                    setValue(true);
                  } else if (value == 1) {
                    setValue(false);
                  }
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Slider(
                    divisions: 50,
                    label: '${theoryTasks.round()}',
                    inactiveColor: Colors.grey,
                    value: theoryTasks,
                    max: 50,
                    min: 0,
                    onChanged: (value) {
                      setState(() {
                        theoryTasks = value;
                      });
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('Количество теоретических вопросов'),
                  ),
                ),
                //Text(_items[0]['tasks'][0]),
                for (var i = 0; i < _items.length; i++)
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      trailing: Checkbox(
                        value: checkMap[i]['all'],
                        onChanged: (bool? value) {
                          setState(() {
                            checkMap[i]['all'] = !checkMap[i]['all'];
                            checkTheme(i);
                          });
                        },
                      ),
                      title: Text(_items[i]['theme']),
                      childrenPadding: EdgeInsets.only(right: 10, left: 10),
                      children: <Widget>[
                        //for (var task in it['tasks'])
                        for (var j = 0; j < _items[i]['tasks'].length; j++)
                          CheckboxListTile(
                            title: Text(_items[i]['tasks'][j]),
                            //controlAffinity: ListTileControlAffinity.leading,
                            value: checkMap[i][j],
                            onChanged: (bool? value) {
                              setState(() {
                                checkMap[i][j] = !checkMap[i][j];
                                checkTask(i);
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Slider(
                    divisions: 50,
                    label: '${variantsCount.round()}',
                    inactiveColor: Colors.grey,
                    value: variantsCount,
                    max: 50,
                    min: 0,
                    onChanged: (value) {
                      setState(() {
                        variantsCount = value;
                      });
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text('Количество вариантов'),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PdfPreviewPage(
                    options: Options(
                        checkMap: checkMap,
                        variantsCount: variantsCount,
                        theoryTasks: theoryTasks)),
              ),
            );
            // rootBundle.
          },
          child: Icon(Icons.picture_as_pdf),
        ),
      ),
    );
  }
}
