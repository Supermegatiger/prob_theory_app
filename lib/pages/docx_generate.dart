import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../options.dart';

class DocxGenerator extends StatelessWidget {
  final Options options;
  const DocxGenerator({super.key, required this.options});
  void func() async {
    final data = await rootBundle.load('assets/template.docx');
    final bytes = data.buffer.asUint8List();
    final docx = await DocxTemplate.fromBytes(bytes);
    Content content = Content();
    content..add(TextContent("name", options.testName));
    // ..add(ListContent("plainlist", [
    //   PlainContent('task1')
    //     ..add(TextContent('t_number', 1))
    //     ..add(TextContent('n1', '6 уебищных'))
    //     ..add(TextContent('n2', '3 сучьих'))
    //     ..add(TextContent('m', 3))
    //     ..add(TextContent('a1', 'шлюший ответ 1'))
    //     ..add(TextContent('a2', 'шлюший ответ 2'))
    //     ..add(TextContent('a3', 'шлюший ответ 3'))
    //     ..add(TextContent('a4', 'шлюший ответ 4'))
    // ]))
    var t = [];
    for (int j = 0; j < options.checkMap.length; j++) {
      for (var k = 0; k < options.checkMap[j].length - 1; k++) {
        //print('$j $k ${options.checkMap[j][k]}');
        t.add(options.checkMap[j][k]);
      }
    }
    for (var i = 0; i < t.length; i++) {
      if (t[i]) {
        content.add(
            PlainContent('task${i + 1}')..add(TextContent('t_number', i + 1)));
      }
    }

    final docGenerated =
        await docx.generate(content, tagPolicy: TagPolicy.saveNullified);
    final fileGenerated = File('generated.docx');
    if (docGenerated != null) {
      try {
        final filePath = await FilePicker.platform.getDirectoryPath();
        File a = File('');
        if (filePath != null) {
          final t = DateTime.now();
          final file = File(
              '$filePath/test_${t.hour.toString()}.${t.minute.toString()}_${t.day.toString()}.${t.month.toString()}.docx');
          a = await file.writeAsBytes(docGenerated);
        }
        if (a.existsSync()) {
          if (isMobile()) {
            Fluttertoast.showToast(
              msg: "Сохранено",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          }
        }
      } catch (ex) {}
    }
  }

  bool isMobile() {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pdfx example'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () async {},
            ),
          ],
        ),
        body: Center(
          child: IconButton(
            icon: Icon(Icons.edit_document),
            onPressed: () => func(),
          ),
        ));
  }
}
