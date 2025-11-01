import 'package:freezed_annotation/freezed_annotation.dart';
import 'address.dart';

part 'business.freezed.dart';
part 'business.g.dart';

@freezed
class Business with _$Business {
  const factory Business({
    required Address address,
    required List<String> categories,
    required String logo,
    required String name,
    required List<String> products,
    required double rating,
  }) = _Business;

  factory Business.fromJson(Map<String, dynamic> json) =>
      _$BusinessFromJson(json);
}
