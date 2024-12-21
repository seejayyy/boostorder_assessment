import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'product_dimensions.g.dart';

@HiveType(typeId: 1) // Unique typeId for Dimensions
class Dimensions extends HiveObject {
  @HiveField(0)
  final String? height;

  @HiveField(1)
  final String? width;

  @HiveField(2)
  final String? length;

  Dimensions({
    this.height,
    this.width,
    this.length,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) {
    return Dimensions(
      height: json['height'],
      width: json['width'],
      length: json['length'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'width': width,
      'length': length,
    };
  }

  @override
  String toString(){
    return '''
      Dimension:
        Height: $height
        Width: $width
        Length: $length
    ''';
  }
}
