import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrcodeGenerator extends StatefulWidget {
  const QrcodeGenerator({Key? key}) : super(key: key);

  @override
  State<QrcodeGenerator> createState() => _QrcodeGeneratorState();
}

class _QrcodeGeneratorState extends State<QrcodeGenerator> {
  // Define the data you want to encode in the QR code.
  final String qrData = 'https://example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: QrImageView(
                  data: 'This is a simple QR code',
                  version: QrVersions.auto,
                  size: 320,
                  gapless: false,
                ),
              ),
              SizedBox(height: 20.0),
              Text('Scan the QR code'),
            ],
          ),
        ),
      ),
    );
  }
}
