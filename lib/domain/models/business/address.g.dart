// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressImpl _$$AddressImplFromJson(Map<String, dynamic> json) =>
    _$AddressImpl(
      direccion: json['direccion'] as String,
      edificio: json['edificio'] as String,
      local: json['local'] as String,
      piso: json['piso'] as String,
      salon: json['salon'] as String,
    );

Map<String, dynamic> _$$AddressImplToJson(_$AddressImpl instance) =>
    <String, dynamic>{
      'direccion': instance.direccion,
      'edificio': instance.edificio,
      'local': instance.local,
      'piso': instance.piso,
      'salon': instance.salon,
    };
