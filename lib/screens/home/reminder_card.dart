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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                child: Image.network(
                  cacheWidth: 100,
                  cacheHeight: 100,
                  reminder.fileUrl!,
                  loadingBuilder:(context, child, loadingProgress) => loadingProgress == null 
                    ? child
                    : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Image.asset(
                        'assets/img/pdf_black.png',
                        width: 100,
                      ),
                    );
                  },
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

Future  _showImageDialog(BuildContext context, String imageUrl, String name) async {
  showDialog(
    context: context, 
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained,
        ),
      );
    }
  );
}

void _showPdfDialog(BuildContext context, String pdfUrl, String pdfName) async {
  File file = await _downloadFile(pdfUrl);
  String localPath = file.path;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title:  Text(pdfName),
        ),
        body: PDFView(
          filePath: localPath,
        ),
      );
    },
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
