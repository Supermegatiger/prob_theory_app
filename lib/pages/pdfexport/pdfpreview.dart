import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:prob_theory_app/options.dart';
import 'package:prob_theory_app/pages/pdfexport/pinch.dart';
import 'package:prob_theory_app/pages/pdfexport/simple.dart';
import 'pdf/pdfexport.dart';

class PdfPreviewPage extends StatefulWidget {
  final Options options;
  const PdfPreviewPage({Key? key, required this.options}) : super(key: key);
  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  double w = 75;
  @override
  Widget build(BuildContext context) {
    void incW(d) {
      setState(() {
        w += d;
        if (w < 50) w = 50;
        if (w > 100) w = 100;
      });
    }

    return Platform.isWindows
        ?
        // Scaffold(
        //     appBar: AppBar(actions: [
        //       IconButton(onPressed: () => incW(-10), icon: Icon(Icons.remove)),
        //       Slider(
        //         inactiveColor: Colors.grey,
        //         value: w,
        //         max: 100,
        //         min: 50,
        //         onChanged: (value) {
        //           setState(() {
        //             w = value;
        //           });
        //         },
        //       ),
        //       IconButton(onPressed: () => incW(10), icon: Icon(Icons.add)),
        //       IconButton(
        //         padding: EdgeInsets.only(left: 20, right: 20),
        //         icon: const Icon(Icons.save),
        //         onPressed: () async {
        //           try {
        //             final da = await makePdf(widget.options);
        //             final filePath =
        //                 await FilePicker.platform.getDirectoryPath();
        //             File a = File('');
        //             if (filePath != null) {
        //               final t = DateTime.now();
        //               final file = File(
        //                   '$filePath/test_${t.hour.toString()}.${t.minute.toString()}_${t.day.toString()}.${t.month.toString()}.pdf');
        //               a = await file.writeAsBytes(da);
        //             }
        //             if (a.existsSync()) {
        //               ScaffoldMessenger.of(context).showSnackBar(
        //                 SnackBar(
        //                   backgroundColor:
        //                       Theme.of(context).colorScheme.background,
        //                   duration: Duration(milliseconds: 1000),
        //                   content: Center(
        //                       child: Text(
        //                     "Сохранено",
        //                     style:
        //                         TextStyle(color: Theme.of(context).hintColor),
        //                   )),
        //                 ),
        //               );
        //             }
        //           } catch (ex) {}
        //         },
        //       ),
        //     ]),
        //     body: Center(
        //       child: Container(
        //         width: w * MediaQuery.of(context).size.width / 100,
        //         child: Text('Huila'),
        //       ),
        //     )
        //     // body: Platform.isWindows
        //     //     ? PdfView(
        //     //         controller: PdfController(
        //     //             document: PdfDocument.openData(makePdf(invoice))),
        //     //       )
        //     //     : PdfViewPinch(
        //     //         controller: PdfControllerPinch(
        //     //             document: PdfDocument.openData(makePdf(invoice))),
        //     //       ),

        //     // body: Platform.isWindows
        //     //     ? SimplePage(
        //     //         invoice: invoice,
        //     //       )
        //     //     : PinchPage(
        //     //         invoice: invoice,
        //     //       ),
        //     )
        Scaffold(
            body: SimplePage(
              options: widget.options,
            ),
          )
        : Scaffold(
            body: PinchPage(
              options: widget.options,
            ),
          );
  }
}
