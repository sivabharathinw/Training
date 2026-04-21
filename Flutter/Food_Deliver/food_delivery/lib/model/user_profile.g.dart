// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserProfile> _$userProfileSerializer = _$UserProfileSerializer();

class _$UserProfileSerializer implements StructuredSerializer<UserProfile> {
  @override
  final Iterable<Type> types = const [UserProfile, _$UserProfile];
  @override
  final String wireName = 'UserProfile';

  @override
  Iterable<Object?> serialize(Serializers serializers, UserProfile object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(object.email,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.profilePictureId;
    if (value != null) {
      result
        ..add('profilePictureId')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  UserProfile deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UserProfileBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'profilePictureId':
          result.profilePictureId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$UserProfile extends UserProfile {
  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String? profilePictureId;

  factory _$UserProfile([void Function(UserProfileBuilder)? updates]) =>
      (UserProfileBuilder()..update(updates))._build();

  _$UserProfile._(
      {required this.id,
      required this.name,
      required this.email,
      this.profilePictureId})
      : super._();
  @override
  UserProfile rebuild(void Function(UserProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileBuilder toBuilder() => UserProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
        id == other.id &&
        name == other.name &&
        email == other.email &&
        profilePictureId == other.profilePictureId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, profilePictureId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserProfile')
          ..add('id', id)
          ..add('name', name)
          ..add('email', email)
          ..add('profilePictureId', profilePictureId))
        .toString();
  }
}

class UserProfileBuilder implements Builder<UserProfile, UserProfileBuilder> {
  _$UserProfile? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _profilePictureId;
  String? get profilePictureId => _$this._profilePictureId;
  set profilePictureId(String? profilePictureId) =>
      _$this._profilePictureId = profilePictureId;

  UserProfileBuilder();

  UserProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _email = $v.email;
      _profilePictureId = $v.profilePictureId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserProfile other) {
    _$v = other as _$UserProfile;
  }

  @override
  void update(void Function(UserProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserProfile build() => _build();

  _$UserProfile _build() {
    final _$result = _$v ??
        _$UserProfile._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserProfile', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UserProfile', 'name'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'UserProfile', 'email'),
          profilePictureId: profilePictureId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
