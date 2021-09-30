import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_reader_alpha/api/pdf_api.dart';
import 'package:pdf_reader_alpha/page/pdf_viewer_page.dart';
import 'package:pdf_reader_alpha/widget/button_widget.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'PDF Viewer';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: const MainPage(),
      );
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                  text: 'Asset PDF',
                  onClicked: () async {
                    const path = 'assets/sample.pdf';
                    final file = await PDFApi.loadAsset(path);
                    openPDF(context, file);
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  text: 'File PDF',
                  onClicked: () async {
                    final file = await PDFApi.pickFile();

                    if (file == null) return;
                    openPDF(context, file);
                  },
                ),
                const SizedBox(height: 16),
                ButtonWidget(
                  text: 'Network PDF',
                  onClicked: () async {
                    const url =
                        'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf';
                    final file = await PDFApi.loadNetwork(url);
                    openPDF(context, file);
                  },
                ),
              ],
            ),
          ),
        ),
      );

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );
}
