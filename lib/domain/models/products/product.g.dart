// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      business: json['business'] as String,
      category: json['category'] as String,
      comments: (json['comments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String,
      image: json['image'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business': instance.business,
      'category': instance.category,
      'comments': instance.comments,
      'description': instance.description,
      'image': instance.image,
      'name': instance.name,
      'price': instance.price,
      'rating': instance.rating,
    };
