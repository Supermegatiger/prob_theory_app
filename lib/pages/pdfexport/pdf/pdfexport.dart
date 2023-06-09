import 'dart:convert';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:prob_theory_app/options.dart';

Future<Uint8List> makePdf(Options options) async {
  final pdf = Document();
  // final imageLogo = MemoryImage(
  //     (await rootBundle.load('assets/technical_logo.png'))
  //         .buffer
  //         .asUint8List());

  final String response =
      await rootBundle.loadString('assets/data/theory.json');
  final data = await json.decode(response);
  String path = 'assets/OpenSans-Regular.ttf';
  Font? mFont = Font.ttf(await rootBundle.load(path));
  for (var i = 0; i < options.variantsCount; i++) {
    pdf.addPage(
      MultiPage(
        theme: ThemeData(defaultTextStyle: TextStyle(font: mFont)),
        build: (context) {
          return [
            Column(
              children: [
                Center(child: Text(options.testName)),
                Center(child: Text('Вариант ${i + 1}')),
                SizedBox(height: 20),
                for (var i = 0; i < data['items'].length; i++)
                  Column(children: [
                    Text('${i + 1}. ${data['items'][i][0]} :',
                        textAlign: TextAlign.left),
                    for (var j = 0; j < data['items'][i][1].length; j++)
                      Text('${j + 1}) ${data['items'][i][1][j]}'),
                  ])
                // Container(height: 50),
                // Table(
                //   border: TableBorder.all(color: PdfColors.black),
                //   children: [
                //     TableRow(
                //       children: [
                //         Padding(
                //           child: Text(
                //             'options FOR PAYMENT',
                //             style: Theme.of(context).header4,
                //             textAlign: TextAlign.center,
                //           ),
                //           padding: const EdgeInsets.all(20),
                //         ),
                //       ],
                //     ),
                //     // ...options.items.map(
                //     //   (e) => TableRow(
                //     //     children: [
                //     //       Expanded(
                //     //         child: PaddedText(e.description),
                //     //         flex: 2,
                //     //       ),
                //     //       Expanded(
                //     //         child: PaddedText("\$${e.cost}"),
                //     //         flex: 1,
                //     //       )
                //     //     ],
                //     //   ),
                //     // ),
                //     // TableRow(
                //     //   children: [
                //     //     PaddedText('TAX', align: TextAlign.right),
                //     //     PaddedText(
                //     //         '\$${(options.totalCost() * 0.1).toStringAsFixed(2)}'),
                //     //   ],
                //     // ),
                //     // TableRow(
                //     //   children: [
                //     //     PaddedText('TOTAL', align: TextAlign.right),
                //     //     PaddedText(
                //     //         '\$${(options.totalCost() * 1.1).toStringAsFixed(2)}')
                //     //   ],
                //     // )
                //   ],
                // ),
                // Padding(
                //   child: Text(
                //     "THANK YOU FOR YOUR CUSTOM!",
                //     style: Theme.of(context).header2,
                //   ),
                //   padding: const EdgeInsets.all(20),
                // ),
                // Text(
                //     "Please forward the below slip to your accounts payable department."),
                // Divider(
                //   height: 1,
                //   borderStyle: BorderStyle.dashed,
                // ),
                // Container(height: 50),
                // Table(
                //   border: TableBorder.all(color: PdfColors.black),
                //   children: [
                //     TableRow(
                //       children: [
                //         PaddedText('Account Number'),
                //         PaddedText(
                //           '1234 1234',
                //         )
                //       ],
                //     ),
                //     TableRow(
                //       children: [
                //         PaddedText(
                //           'Account Name',
                //         ),
                //         PaddedText(
                //           'ADAM FAMILY TRUST',
                //         )
                //       ],
                //     ),
                //     TableRow(
                //       children: [
                //         PaddedText(
                //           'Total Amount to be Paid',
                //         ),
                //         // PaddedText(
                //         //     '\$${(options.totalCost() * 1.1).toStringAsFixed(2)}')
                //       ],
                //     )
                //   ],
                // ),
                // Container(height: 50),
                // Table(
                //   border: TableBorder.all(color: PdfColors.black),
                //   children: [
                //     TableRow(
                //       children: [
                //         PaddedText('Account Number'),
                //         PaddedText(
                //           '1234 1234',
                //         )
                //       ],
                //     ),
                //     TableRow(
                //       children: [
                //         PaddedText(
                //           'Account Name',
                //         ),
                //         PaddedText(
                //           'ADAM FAMILY TRUST',
                //         )
                //       ],
                //     ),
                //     TableRow(
                //       children: [
                //         PaddedText(
                //           'Total Amount to be Paid',
                //         ),
                //         // PaddedText(
                //         //     '\$${(options.totalCost() * 1.1).toStringAsFixed(2)}')
                //       ],
                //     )
                //   ],
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(30),
                //   child: Text(
                //     'Please ensure all cheques are payable to the ADAM FAMILY TRUST.',
                //     style: Theme.of(context).header3.copyWith(
                //           fontStyle: FontStyle.italic,
                //         ),
                //     textAlign: TextAlign.center,
                //   ),
                // )
              ],
            )
          ];
        },
      ),
    );
  }
  return pdf.save();
}

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.left,
}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );
