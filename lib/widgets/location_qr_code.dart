import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_theme.dart';

/// Google Maps link for the wedding venue (My home).
const String kGoogleMapsVenueUrl =
    'https://www.google.com/maps/place/My+home/@12.7335663,103.6645446,20.35z/data=!4m12!1m5!3m4!2zMTLCsDQ0JzAxLjAiTiAxMDPCsDM5JzUyLjgiRQ!8m2!3d12.7336118!4d103.6646693!3m5!1s0x310f8d004abb283b:0xccc64d3369929268!8m2!3d12.7336786!4d103.6647524!16s%2Fg%2F11x7mddg0l!5m1!1e1?entry=ttu';

/// QR code that encodes the venue Google Maps URL; tap to open in browser/maps.
class LocationQrCode extends StatelessWidget {
  const LocationQrCode({
    super.key,
    this.size = 200,
  });

  final double size;

  Future<void> _openMap(BuildContext context) async {
    final uri = Uri.parse(kGoogleMapsVenueUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _openMap(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: size,
          height: size,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.lightLavender),
          ),
          child: QrImageView(
            data: kGoogleMapsVenueUrl,
            version: QrVersions.auto,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppTheme.deepPurple,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppTheme.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
