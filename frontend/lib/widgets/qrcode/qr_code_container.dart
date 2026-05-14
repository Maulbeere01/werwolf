import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:werwolf/widgets/qrcode/floating_container.dart';

class QRCodeContainer extends StatelessWidget {
  final double width;
  final double height;
  final String dataToEncode = "Dein Text oder Link hier";

  const QRCodeContainer({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingContainer(
        width: width,
        height: height,
        child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Center(
          child:QrImageView(
            data: dataToEncode,
            version: QrVersions.auto,
            size: 200.0,
            gapless: false,
            // Optional: Styling
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: Colors.black,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: Colors.black,
            ),
        ),
      ),
        )
    );
  }
}