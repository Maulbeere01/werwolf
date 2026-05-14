import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:werwolf/Views/CreateGame/join_create_view.dart';
import 'package:werwolf/widgets/qrcode/floating_container.dart';

class CameraContainer extends StatefulWidget {
  final double width;
  final double height;

  const CameraContainer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  State<CameraContainer> createState() => _CameraContainerState();
}

class _CameraContainerState extends State<CameraContainer> {
  bool _hasScanned = false;

  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingContainer(
      width: 300,
      height: 300,
      child: MobileScanner(
        controller: controller,
        onDetect: (capture) {
          if (_hasScanned) return;

          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            if (barcode.rawValue != null) {
              setState(() {
                _hasScanned = true;
              });

              debugPrint('QR Code gefunden: ${barcode.rawValue}');

              //Geht momentan noch ins Hauptmenü zurück
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => JoinCreateView()),
              );


              break;
            }
          }
        },
      ),
    );
  }
}