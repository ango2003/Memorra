import 'package:flutter/material.dart';
import 'package:flutter_frontend/services/deep_link_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';

class ScanQrPage extends StatefulWidget{
  const ScanQrPage({super.key});

  @override
  State<ScanQrPage> createState() => ScanQrPageState();
}

class ScanQrPageState extends State<ScanQrPage> {
  
  bool isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: 
        Stack(
          children: [
            MobileScanner(
              onDetect: (capture) async {
            if (isProcessing) return;
            isProcessing = true;

            if (capture.barcodes.isEmpty) {
              isProcessing = false;
              return;
            }
            final barcode = capture.barcodes.first;
            
            final value = barcode.rawValue;
            if (value == null) {
              isProcessing = false;
              return;
            }
            
            HapticFeedback.mediumImpact();

            final localContext = context;
            final uri = Uri.parse(barcode.rawValue!);
            final success = await DeepLinkService.instance.handleIncomingLink(uri);

            if (!mounted || !localContext.mounted) return;

            if (success) {
              ScaffoldMessenger.of(localContext).showSnackBar(
                const SnackBar(content: Text('Connected Successfully'))
              );
              Navigator.pushReplacementNamed(localContext, '/connectionspage');
            } else {
              isProcessing = false;
              ScaffoldMessenger.of(localContext).showSnackBar(
                const SnackBar(content: Text('Invalid or expired invite'))
              );
            }
          }
        ),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              'Scan a Memorra invite QR code',
              style: TextStyle(color: Colors.white),
            )
          ),
        ),
        Center(
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width:  2,
              )
            )
          )
        )
      ]
      )
    );
  }
}