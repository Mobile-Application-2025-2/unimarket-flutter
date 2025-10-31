// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Address _$AddressFromJson(Map<String, dynamic> json) {
  return _Address.fromJson(json);
}

/// @nodoc
mixin _$Address {
  String get direccion => throw _privateConstructorUsedError;
  String get edificio => throw _privateConstructorUsedError;
  String get local => throw _privateConstructorUsedError;
  String get piso => throw _privateConstructorUsedError;
  String get salon => throw _privateConstructorUsedError;

  /// Serializes this Address to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressCopyWith<Address> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressCopyWith<$Res> {
  factory $AddressCopyWith(Address value, $Res Function(Address) then) =
      _$AddressCopyWithImpl<$Res, Address>;
  @useResult
  $Res call({
    String direccion,
    String edificio,
    String local,
    String piso,
    String salon,
  });
}

/// @nodoc
class _$AddressCopyWithImpl<$Res, $Val extends Address>
    implements $AddressCopyWith<$Res> {
  _$AddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direccion = null,
    Object? edificio = null,
    Object? local = null,
    Object? piso = null,
    Object? salon = null,
  }) {
    return _then(
      _value.copyWith(
            direccion: null == direccion
                ? _value.direccion
                : direccion // ignore: cast_nullable_to_non_nullable
                      as String,
            edificio: null == edificio
                ? _value.edificio
                : edificio // ignore: cast_nullable_to_non_nullable
                      as String,
            local: null == local
                ? _value.local
                : local // ignore: cast_nullable_to_non_nullable
                      as String,
            piso: null == piso
                ? _value.piso
                : piso // ignore: cast_nullable_to_non_nullable
                      as String,
            salon: null == salon
                ? _value.salon
                : salon // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddressImplCopyWith<$Res> implements $AddressCopyWith<$Res> {
  factory _$$AddressImplCopyWith(
    _$AddressImpl value,
    $Res Function(_$AddressImpl) then,
  ) = __$$AddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String direccion,
    String edificio,
    String local,
    String piso,
    String salon,
  });
}

/// @nodoc
class __$$AddressImplCopyWithImpl<$Res>
    extends _$AddressCopyWithImpl<$Res, _$AddressImpl>
    implements _$$AddressImplCopyWith<$Res> {
  __$$AddressImplCopyWithImpl(
    _$AddressImpl _value,
    $Res Function(_$AddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direccion = null,
    Object? edificio = null,
    Object? local = null,
    Object? piso = null,
    Object? salon = null,
  }) {
    return _then(
      _$AddressImpl(
        direccion: null == direccion
            ? _value.direccion
            : direccion // ignore: cast_nullable_to_non_nullable
                  as String,
        edificio: null == edificio
            ? _value.edificio
            : edificio // ignore: cast_nullable_to_non_nullable
                  as String,
        local: null == local
            ? _value.local
            : local // ignore: cast_nullable_to_non_nullable
                  as String,
        piso: null == piso
            ? _value.piso
            : piso // ignore: cast_nullable_to_non_nullable
                  as String,
        salon: null == salon
            ? _value.salon
            : salon // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressImpl implements _Address {
  const _$AddressImpl({
    required this.direccion,
    required this.edificio,
    required this.local,
    required this.piso,
    required this.salon,
  });

  factory _$AddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressImplFromJson(json);

  @override
  final String direccion;
  @override
  final String edificio;
  @override
  final String local;
  @override
  final String piso;
  @override
  final String salon;

  @override
  String toString() {
    return 'Address(direccion: $direccion, edificio: $edificio, local: $local, piso: $piso, salon: $salon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressImpl &&
            (identical(other.direccion, direccion) ||
                other.direccion == direccion) &&
            (identical(other.edificio, edificio) ||
                other.edificio == edificio) &&
            (identical(other.local, local) || other.local == local) &&
            (identical(other.piso, piso) || other.piso == piso) &&
            (identical(other.salon, salon) || other.salon == salon));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, direccion, edificio, local, piso, salon);

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      __$$AddressImplCopyWithImpl<_$AddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressImplToJson(this);
  }
}

abstract class _Address implements Address {
  const factory _Address({
    required final String direccion,
    required final String edificio,
    required final String local,
    required final String piso,
    required final String salon,
  }) = _$AddressImpl;

  factory _Address.fromJson(Map<String, dynamic> json) = _$AddressImpl.fromJson;

  @override
  String get direccion;
  @override
  String get edificio;
  @override
  String get local;
  @override
  String get piso;
  @override
  String get salon;

  /// Create a copy of Address
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressImplCopyWith<_$AddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
