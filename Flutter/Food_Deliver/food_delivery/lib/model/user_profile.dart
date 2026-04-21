library user_profile;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_profile.g.dart';

abstract class UserProfile implements Built<UserProfile, UserProfileBuilder> {
  String get id;
  String get name;
  String get email;
  @BuiltValueField(wireName: 'profilePictureId')
  String? get profilePictureId;

  UserProfile._();
  factory UserProfile([void Function(UserProfileBuilder) updates]) = _$UserProfile;

  static Serializer<UserProfile> get serializer => _$userProfileSerializer;
}
