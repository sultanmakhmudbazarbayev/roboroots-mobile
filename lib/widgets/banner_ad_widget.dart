import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      // Test ad unit ID for banners:
      adUnitId: 'ca-app-pub-3008087842634597/6943097118',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print("Banner ad loaded.");
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Banner ad failed to load: ${error.message}');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      // Display a placeholder so the space is reserved.
      return SizedBox(
        width: AdSize.banner.width.toDouble(),
        height: AdSize.banner.height.toDouble(),
      );
    }
  }
}
