
import 'package:json_annotation/json_annotation.dart';

part 'jwt_model.g.dart';

@JsonSerializable()
class JwtModel {

  String jwt;

  String refreshToken;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory JwtModel.fromJson(Map<String, dynamic> json) => _$JwtModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$JwtModelToJson(this);

  JwtModel(this.jwt, this.refreshToken);
}
