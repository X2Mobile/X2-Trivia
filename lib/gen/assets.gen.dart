/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/all_categories.png
  AssetGenImage get allCategories =>
      const AssetGenImage('assets/icons/all_categories.png');

  /// File path: assets/icons/anime.png
  AssetGenImage get anime => const AssetGenImage('assets/icons/anime.png');

  /// File path: assets/icons/general_knowledge.png
  AssetGenImage get generalKnowledge =>
      const AssetGenImage('assets/icons/general_knowledge.png');

  /// File path: assets/icons/history.png
  AssetGenImage get history => const AssetGenImage('assets/icons/history.png');

  /// File path: assets/icons/radio_button_checked.svg
  String get radioButtonChecked => 'assets/icons/radio_button_checked.svg';

  /// File path: assets/icons/radio_button_unchecked.svg
  String get radioButtonUnchecked => 'assets/icons/radio_button_unchecked.svg';

  /// File path: assets/icons/sports.png
  AssetGenImage get sports => const AssetGenImage('assets/icons/sports.png');

  /// File path: assets/icons/x2logo.svg
  String get x2logo => 'assets/icons/x2logo.svg';

  /// File path: assets/icons/x2logo_home.svg
  String get x2logoHome => 'assets/icons/x2logo_home.svg';

  /// List of all assets
  List<dynamic> get values => [
        allCategories,
        anime,
        generalKnowledge,
        history,
        radioButtonChecked,
        radioButtonUnchecked,
        sports,
        x2logo,
        x2logoHome
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const AssetGenImage saveScore = AssetGenImage('assets/save_score.png');

  /// List of all assets
  static List<AssetGenImage> get values => [saveScore];
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
