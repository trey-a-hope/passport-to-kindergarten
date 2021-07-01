import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:p/widgets/AppBarWidget.dart';

import 'constants.dart';

class PDFView extends StatefulWidget {
  PDFView({
    @required this.assetPath,
    @required this.appBarTitle,
  });

  final String assetPath;
  final String appBarTitle;

  @override
  _PDFViewState createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFView> {
  bool _isLoading = true;
  PDFDocument _pdfDocument;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    _pdfDocument = await PDFDocument.fromAsset(widget.assetPath);
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.grey.shade200,
        child: SafeArea(
          child: Column(
            children: [
              AppBarWidget(title: widget.appBarTitle),
              Expanded(
                child: Center(
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : PDFViewer(
                          document: _pdfDocument,
                          zoomSteps: 1,
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
