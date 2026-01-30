import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PdfService {
  Future<String> createPdfFromImages(
    List<String> imagePaths,
    String fileName,
  ) async {
    final pdf = pw.Document();

    for (final imagePath in imagePaths) {
      final image = pw.MemoryImage(File(imagePath).readAsBytesSync());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(child: pw.Image(image));
          },
        ),
      );
    }

    Directory? output;
    if (Platform.isAndroid) {
      output = await getExternalStorageDirectory();
    }
    output ??= await getApplicationDocumentsDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
