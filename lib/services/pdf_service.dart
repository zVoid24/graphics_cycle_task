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

    // Create Documents/DocScan subdirectory if possible to be more organized?
    // getExternalStorageDirectory points to Android/data/package.../files
    // We can't easily write to /Documents without permissions logic.
    // Stick to app-specific external for now as it doesn't need runtime permission for own folder on 19+.

    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
