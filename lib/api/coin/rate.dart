
import 'package:json_annotation/json_annotation.dart';

part 'rate.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Rate {
  final DateTime time;
  final String assetIdBase;
  final String assetIdQuote;
  final double rate;

  Rate(this.time, this.assetIdBase, this.assetIdQuote, this.rate);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Rate.fromJson(Map<String, dynamic> json) => _$RateFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RateToJson(this);
}