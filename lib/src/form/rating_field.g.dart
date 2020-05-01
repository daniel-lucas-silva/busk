part of 'rating_field.dart';

class RatingSettings {
  final int itemCount;
  final double itemSize;
  final bool allowHalfRating;
  final EdgeInsets itemPadding;
  final bool ignoreGestures;
  final bool tapOnlyMode;
  final TextDirection textDirection;
  final Widget icon;
  final Axis direction;
  final Color unratedColor;

  const RatingSettings({
    this.itemCount = 5,
    this.itemSize = 24.0,
    this.allowHalfRating = false,
    this.itemPadding = EdgeInsets.zero,
    this.ignoreGestures = false,
    this.tapOnlyMode = false,
    this.textDirection,
    this.icon: const SimpleIcon(
      CupertinoIcons.star_filled,
      color: CupertinoColors.systemYellow,
    ),
    this.direction = Axis.horizontal,
    this.unratedColor,
  });

  RatingSettings copyWith({
    int itemCount,
    double itemSize,
    bool allowHalfRating,
    EdgeInsets itemPadding,
    bool ignoreGestures,
    bool tapOnlyMode,
    TextDirection textDirection,
    Widget icon,
    Axis direction,
    Color unratedColor,
  }) {
    return RatingSettings(
      itemCount: itemCount ?? this.itemCount,
      itemSize: itemSize ?? this.itemSize,
      allowHalfRating: allowHalfRating ?? this.allowHalfRating,
      itemPadding: itemPadding ?? this.itemPadding,
      ignoreGestures: ignoreGestures ?? this.ignoreGestures,
      tapOnlyMode: tapOnlyMode ?? this.tapOnlyMode,
      textDirection: textDirection ?? this.textDirection,
      icon: icon ?? this.icon,
      direction: direction ?? this.direction,
      unratedColor: unratedColor ?? this.unratedColor,
    );
  }
}