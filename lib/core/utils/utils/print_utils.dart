import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

Future<void> printTextDoc({required String title, required String body}) async {
  final doc = pw.Document();
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        pw.Header(level: 0, child: pw.Text(title)),
        pw.Divider(),
        pw.Text(body),
      ],
    ),
  );
  await Printing.layoutPdf(onLayout: (format) async => doc.save());
}
