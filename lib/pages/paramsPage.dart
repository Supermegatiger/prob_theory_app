import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prob_theory_app/options.dart';
import 'package:prob_theory_app/pages/docx_generate.dart';
import 'dart:convert';
import '../task.dart';
import '../taskGeneration.dart';

class ParamsPage extends StatefulWidget {
  const ParamsPage({super.key, required this.title});

  final String title;

  @override
  State<ParamsPage> createState() => _ParamsPageState();
}

class _ParamsPageState extends State<ParamsPage> {
  var checkMap = {};
  List _items = [];
  double theoryCount = 0;
  double variantsCount = 3;
  final testNameController = TextEditingController();
  // Fetch content from the json file
  Future<void> readData() async {
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
    readData();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    testNameController.dispose();
    super.dispose();
  }

  bool isMobile() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return false;
    } else {
      return true;
    }
  }

  void func() async {
    final String response =
        await rootBundle.loadString('assets/data/theory.json');
    final data1 = await json.decode(response);
    final theory = data1['items'];
    // файл шаблона тестов
    final fileData = await rootBundle.load('assets/template.docx');
    final bytes = fileData.buffer.asUint8List();
    final docx = await DocxTemplate.fromBytes(bytes);
    // файл шаблона ключей
    final fileData1 = await rootBundle.load('assets/keys.docx');
    final bytes1 = fileData1.buffer.asUint8List();
    final docx1 = await DocxTemplate.fromBytes(bytes1);
    var t = [];
    for (int j = 0; j < checkMap.length; j++) {
      for (var k = 0; k < checkMap[j].length - 1; k++) {
        //print('$j $k ${options.checkMap[j][k]}');
        t.add(checkMap[j][k]);
      }
    }

    Content content = Content();
    Content keyCont = Content();
    List<Content> temp = [];
    var qs = [for (var i = 0; i < theory.length; i += 1) i];
    var keys = {};
    var tasksCount = 0;
    for (int v = 0; v < variantsCount; v++) {
      PlainContent pc = PlainContent('variant');
      pc.add(TextContent("name", testNameController.text));
      pc.add(TextContent("varnum", v + 1));
      var key = {};
      keys[v + 1] = key;
      int j = 0;
      // рандомим вопросы
      shuffle(qs);
      if (theoryCount != 0) {
        List<Content> list = [];
        for (var i = 0; i < theoryCount; i++) {
          j++;
          var t = PlainContent('plain')..add(TextContent('t_number', j));
          var title = theory[qs[i]][0];
          var ans = theory[qs[i]][1];
          var ri = ans[0];
          shuffle(ans);
          t.add(TextContent('title', title));
          for (int k = 0; k < 4; k++) {
            t.add(TextContent('v$k', ans[k]));
          }
          key[j] = ans.indexOf(ri) + 1;
          list.add(t);
        }
        pc.add(ListContent(('quest'), list));
      }
      for (var i = 0; i < t.length; i++) {
        if (t[i] == true) {
          j++;
          var t = PlainContent('task')..add(TextContent('t_number', j));
          late Task task;
          switch (i) {
            case 0:
              task = tasks[0]();
              t
                ..add(TextContent('n1', task.data['n1']))
                ..add(TextContent('n2', task.data['n2']))
                ..add(TextContent('m', task.data['m']));
              for (int k = 0; k < 4; k++) {
                t.add(TextContent('v$k', task.answers[k]));
              }
              break;
            case 1:
              task = tasks[1]();
              t
                ..add(TextContent('n1', task.data['n1']))
                ..add(TextContent('n2', task.data['n2']))
                ..add(TextContent('m', task.data['m']));
              for (int k = 0; k < 4; k++) {
                t.add(TextContent('v$k', task.answers[k]));
              }
              break;
            case 2:
              task = tasks[2]();
              t
                ..add(TextContent(
                    'p1', task.data['p1'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p2', task.data['p2'].toString().replaceAll('.', ',')));
              for (int k = 0; k < 4; k++) {
                t.add(TextContent('v$k', task.answers[k]));
              }
              break;
            case 3:
              task = tasks[3]();
              t
                ..add(TextContent(
                    'p1', task.data['p1'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p2', task.data['p2'].toString().replaceAll('.', ',')));
              for (int k = 0; k < 4; k++) {
                t.add(TextContent('v$k', task.answers[k]));
              }
              break;
            case 4:
              task = tasks[4]();
              t
                ..add(TextContent('n1', task.data['n1']))
                ..add(TextContent('n2', task.data['n2']))
                ..add(TextContent(
                    'p1', task.data['p1'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p2', task.data['p2'].toString().replaceAll('.', ',')));
              for (int k = 0; k < 4; k++) {
                t.add(TextContent('v$k', task.answers[k]));
              }
              break;
            case 5:
              task = tasks[5]();
              t
                ..add(TextContent('n', task.data['n']))
                ..add(TextContent('m', task.data['m']))
                ..add(TextContent(
                    'p', task.data['p'].toString().replaceAll('.', ',')));
              for (int k = 0; k < 4; k++) {
                t.add(TextContent('v$k', task.answers[k]));
              }
              break;
            case 6:
              task = tasks[6]();
              t
                ..add(TextContent('x1', task.data['x1']))
                ..add(TextContent('x2', task.data['x2']))
                ..add(TextContent('x3', task.data['x3']))
                ..add(TextContent(
                    'p1', task.data['p1'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p2', task.data['p2'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p3', task.data['p3'].toString().replaceAll('.', ',')));
              for (int k = 0; k < 4; k++) {
                for (var l = 0; l < 4; l++) {
                  t.add(TextContent('v$k$l', task.answers[k][l]));
                }
              }
              break;
            case 7:
              task = tasks[7]();
              t
                ..add(TextContent(
                    'p1', task.data['p1'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p2', task.data['p2'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p3', task.data['p3'].toString().replaceAll('.', ',')));
              for (int k = 0; k < 4; k++) {
                for (var l = 0; l < 2; l++) {
                  t.add(TextContent('v$k$l', task.answers[k][l]));
                }
              }
              break;
            case 8:
              task = tasks[8]();
              for (int k = 0; k < 4; k++) {
                for (var l = 0; l < 3; l++) {
                  t.add(TextContent('v$k$l', task.answers[k][l]));
                }
              }
              break;
            case 9:
              task = tasks[9]();
              t
                ..add(TextContent('x1', task.data['x1']))
                ..add(TextContent('x2', task.data['x2']));
              for (int k = 0; k < 4; k++) {
                t.add(TextContent('v$k', task.answers[k]));
              }
              break;
            case 10:
              task = tasks[10]();
              t.add(TextContent('la', task.data['la']));
              for (int k = 0; k < 4; k++) {
                for (var l = 0; l < 2; l++) {
                  t.add(TextContent('v$k$l', task.answers[k][l]));
                }
              }
              break;
            case 11:
              task = tasks[11]();
              t
                ..add(TextContent('x1', task.data['x1']))
                ..add(TextContent('x2', task.data['x2']))
                ..add(TextContent('x3', task.data['x3']))
                ..add(TextContent(
                    'p1', task.data['p1'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p2', task.data['p2'].toString().replaceAll('.', ',')))
                ..add(TextContent(
                    'p3', task.data['p3'].toString().replaceAll('.', ',')));
              for (int k = 0; k < 4; k++) {
                for (var l = 0; l < 2; l++) {
                  t.add(TextContent('v$k$l', task.answers[k][l]));
                }
              }
              break;
            case 12:
              task = tasks[12]();
              t.add(TextContent('x', task.data['x']));
              for (int k = 0; k < 4; k++) {
                for (var l = 0; l < 2; l++) {
                  t.add(TextContent('v$k$l', task.answers[k][l]));
                }
              }
              break;
            default:
          }
          key[j] = task.rightAns + 1;
          pc.add(ListContent('task${i + 1}', [t]));
        }
        // else {
        //   content.add(ListContent('task${i + 1}', []));
        // }
      }
      tasksCount = j;
      temp.add(pc);
    }
    //print(keys);

    PlainContent pl = PlainContent('tabel');
    var rs = <RowContent>[];
    RowContent r = RowContent();
    r.add(TextContent('col0', '№\\В.'));
    for (int i = 0; i < variantsCount; i++) {
      r.add(TextContent('col${i + 1}', '${i + 1}в'));
    }
    for (int i = variantsCount.toInt(); i < 15; i++) {
      r.add(TextContent('col${i + 1}', ''));
    }
    rs.add(r);
    for (int i = 0; i < tasksCount; i++) {
      RowContent tr = RowContent();
      tr.add(TextContent('col0', i + 1));
      for (int j = 0; j < variantsCount; j++) {
        tr.add(TextContent('col${j + 1}', keys[j + 1][i + 1]));
      }
      for (int i = variantsCount.toInt(); i < 15; i++) {
        tr.add(TextContent('col${i + 1}', ''));
      }
      rs.add(tr);
    }
    TableContent tc = TableContent('task', rs);
    pl.add(tc);

    keyCont.add(TextContent('name', testNameController.text));
    keyCont.add(pl);
    content.add(ListContent('variantList', temp));
    var docGenerated =
        await docx.generate(content, tagPolicy: TagPolicy.saveNullified);
    var doc1Generated =
        await docx1.generate(keyCont, tagPolicy: TagPolicy.saveNullified);
    if (docGenerated != null) {
      Content c1 = Content();
      var docx1 = await DocxTemplate.fromBytes(docGenerated);
      docGenerated = await docx1.generate(c1, tagPolicy: TagPolicy.removeAll);
      docx1 = await DocxTemplate.fromBytes(doc1Generated!);
      doc1Generated = await docx1.generate(c1, tagPolicy: TagPolicy.removeAll);
      if (docGenerated != null) {
        // final appDir = await syspaths.getTemporaryDirectory();
        // File fileGenerated = File('${appDir.path}/generated.docx');
        // await fileGenerated.writeAsBytes(docGenerated);
        try {
          final filePath = await FilePicker.platform.getDirectoryPath();
          File a = File('');
          if (filePath != null) {
            final t = DateTime.now();
            final file = File(
                '$filePath/test-${t.year.toString()}-${t.month.toString()}-${t.day.toString()}_${t.hour.toString()}-${t.minute.toString()}-${t.second.toString()}.docx');
            final keyFile = File(
                '$filePath/keys-${t.year.toString()}-${t.month.toString()}-${t.day.toString()}_${t.hour.toString()}-${t.minute.toString()}-${t.second.toString()}.docx');
            a = await file.writeAsBytes(docGenerated);
            await keyFile.writeAsBytes(doc1Generated!);
          }
          if (a.existsSync()) {
            if (isMobile()) {
              Fluttertoast.showToast(
                msg: "Сохранено",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            }
            await OpenFile.open('$filePath\\');
          }
        } catch (ex) {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.save),
            //   onPressed: () => func(),
            // ),
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
                Center(
                  child: SizedBox(
                    width: 500,
                    child: TextField(
                      controller: testNameController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Название теста',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Slider(
                    divisions: 5,
                    label: '${theoryCount.round()}',
                    inactiveColor: Colors.grey,
                    value: theoryCount,
                    max: 5,
                    min: 0,
                    onChanged: (value) {
                      setState(() {
                        theoryCount = value;
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
                    divisions: 15,
                    label: '${variantsCount.round()}',
                    inactiveColor: Colors.grey,
                    value: variantsCount,
                    max: 15,
                    min: 1,
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
          onPressed: () => func(),
          // rootBundle.
          child: Icon(Icons.edit_document),
        ),
      ),
    );
  }
}
