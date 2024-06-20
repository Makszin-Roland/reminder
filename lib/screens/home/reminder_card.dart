import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:intl/intl.dart';
import 'package:reminder/models/reminder.dart';
import 'package:reminder/theme.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:async';
import 'package:photo_view/photo_view.dart';

class ReminderCard extends StatelessWidget {
  const ReminderCard(this.reminder, {super.key});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      shadowColor: Colors.white,
      elevation: 8.0,
      color: AppColors.buttonColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 10, top: 5, bottom: 5),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Title
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Icon(Icons.subtitles),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: reminder.title,
                          style: const TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(
                    height: 10,
                  ),

                  //Note
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Icon(Icons.speaker_notes),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: reminder.notes,
                          style: const TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(
                    height: 10,
                  ),

                  //Date
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Icon(Icons.today),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: DateFormat('dd.MM.yyyy')
                              .format(reminder.valability),
                          style: const TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(
                    height: 10,
                  ),

                  //id
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const Icon(Icons.subtitles),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: reminder.id,
                          style: const TextStyle(
                            color: Colors.black,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),

            //image / pdf
            if (reminder.fileUrl != null)
              GestureDetector(
                onTap: () async {
                  bool isPdf = await _isPdf(reminder.fileUrl!);
                  if (isPdf) {
                    _showPdfDialog(context, reminder.fileUrl!, reminder.filename!);
                  } else {
                    _showImageDialog(context, reminder.fileUrl!, reminder.filename!);
                  }
                },
                child: ClipRRect( 
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),                
                  child: Image.network(                
                    cacheWidth: 130,
                    cacheHeight: 130,
                    fit: BoxFit.contain,
                    reminder.fileUrl!,
                    loadingBuilder:(context, child, loadingProgress) => loadingProgress == null 
                      ? child
                      : const Center(child: CircularProgressIndicator()),
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Image.asset(
                          'assets/img/pdf_black.png',
                          width: 130,
                        ),
                      );
                    },
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

Future<bool> _isPdf(String url) async {
  final response = await http.head(Uri.parse(url));
  return response.headers['content-type'] == 'application/pdf';
}

Future<void> _showImageDialog(BuildContext context, String imageUrl, String name) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenImagePage(imageUrl: imageUrl, name: name),
    ),
  );
}

void _showPdfDialog(BuildContext context, String pdfUrl, String pdfName) async {
  File file = await _downloadFile(pdfUrl);
  String localPath = file.path;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FullScreenPdfPage(pdfPath: localPath, pdfName: pdfName),
    ),
  );
}

Future<File> _downloadFile(String url) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, p.basename(url)));
  await file.writeAsBytes(bytes);
  return file;
}

class FullScreenImagePage extends StatelessWidget {
  final String imageUrl;
  final String name;

  const FullScreenImagePage({
    super.key,
    required this.imageUrl,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //title: Text(name),
      ),
      body: Center(
        child: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: AppColors.primaryColor,
          ),
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
        ),
      ),
    );
  }
}

class FullScreenPdfPage extends StatelessWidget {
  final String pdfPath;
  final String pdfName;

  const FullScreenPdfPage({
    super.key,
    required this.pdfPath,
    required this.pdfName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pdfName),
      ),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}
