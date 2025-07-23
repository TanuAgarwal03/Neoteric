import 'package:flutter/material.dart';
import 'package:neoteric_flutter/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  _PriceListScreenState createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<HomeProvider>().getPriceList();
      _navigateToPDF();
    });
  }

  void _navigateToPDF() {
    final priceList = context.read<HomeProvider>().getAllPriceList;

    if (priceList != null && priceList.isNotEmpty) {
      final url = priceList.first.image;

      if (url != null && url.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PDFWebViewScreen(driveUrl: url),
          ),
        );
      } else {
        _showSnackBar('Price list URL is empty');
      }
    } else {
      _showSnackBar('Price list data not loaded yet');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    // Optionally go back if there’s nothing to do
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HomeProvider>(
        builder: (context, provider, _) {
          final priceList = provider.getAllPriceList;

          if (priceList == null) {
            return const Center(child: CircularProgressIndicator());
          } else if (priceList.isNotEmpty && priceList.first.image != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => PDFWebViewScreen(
                    driveUrl: priceList.first.image!,
                  ),
                ),
              );
            });
            return Container(); // temporary blank UI
          } else {
            return const Center(child: Text('Work Charges not available'));
          }
        },
      ),
    );
  }
}

class PDFWebViewScreen extends StatefulWidget {
  final String driveUrl;
  const PDFWebViewScreen({super.key, required this.driveUrl});

  @override
  State<PDFWebViewScreen> createState() => _PDFWebViewScreenState();
}

class _PDFWebViewScreenState extends State<PDFWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.driveUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Work Charges')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
