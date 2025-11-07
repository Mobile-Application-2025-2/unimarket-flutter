// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  businessId: json['businessId'] as String,
  productId: json['productId'] as String,
  units: (json['units'] as num).toInt(),
  userId: json['userId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'productId': instance.productId,
      'units': instance.units,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
