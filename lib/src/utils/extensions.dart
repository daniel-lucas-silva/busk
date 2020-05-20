import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

extension MapExtension on Map {
  E find<E>(String path, [E or]) {
    final List<String> keys = path.split(".");

    if (keys.length == 1)
      return this.containsKey(path) ? this[path] : or ?? null;

    dynamic result = this;

    keys.reduce((prev, curr) {
      if (result is Map &&
          result.containsKey(prev) &&
          result[prev] is Map &&
          result[prev].containsKey(curr)) {
        result = result[prev][curr];
      } else if (result is Map && result.containsKey(curr)) {
        result = result[curr];
      } else {
        result = or ?? null;
      }
      return curr;
    });

    if (or != null && or.runtimeType != result.runtimeType) return or;
    return result ?? or ?? null;
  }

  E findOr<E>(String path, String path2, [E or]) {
    return this.find(path) ?? this.find(path2) ?? or;
  }

  T containsOrFirst<K, T>(K value, [T or]) {
    if (this.isNotEmpty && this.containsKey(value))
      return this[value];
    else if (this.isNotEmpty)
      return this.values.first;
    else
      return or;
  }
}

extension DateExtension on DateTime {
  String toYYYYMMDD() => this.toString().split(" ")[0];

  String toDDMMYYYY() => DateFormat.yMd('pt_BR').format(this);

  String format([String pattern]) =>
      DateFormat(pattern ?? 'dd/MM/yyyy  HH:mm:ss', 'pt_BR').format(this);
}

extension StringExtension on String {
  String ifEmpty(String value) => (this == null || this.isEmpty) ? value : this;

  Text toText([String or, TextStyle style]) => (this == null || this.isEmpty)
      ? (or == null || or.isEmpty) ? null : Text(or, style: style)
      : Text(this, style: style);

  ImageProvider toImageOrAsset(String value) =>
      (this != null && this.isNotEmpty)
          ? CachedNetworkImageProvider(this)
          : AssetImage(value);
}

extension IterableExtension on Iterable {
  T firstOr<T>(T value) => this.isEmpty ? value : this;

  T elementAtOrNull<T>(int index, [T optional]) {
    if (this.isEmpty) return optional;

    int elementIndex = 0;
    for (T element in this) {
      if (index == elementIndex) return element;
      elementIndex++;
    }

    return optional;
  }
}
