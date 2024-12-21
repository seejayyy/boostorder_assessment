import 'package:hive/hive.dart';

part 'product_image.g.dart';

@HiveType(typeId: 3) // Unique typeId for ImageData
class ImageData extends HiveObject {
  @HiveField(0)
  final String src;

  @HiveField(1)
  final String srcSmall;

  @HiveField(2)
  final String srcMedium;

  @HiveField(3)
  final String srcLarge;

  ImageData({
    required this.src,
    required this.srcSmall,
    required this.srcMedium,
    required this.srcLarge,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      src: json['src'],
      srcSmall: json['src_small'],
      srcMedium: json['src_medium'],
      srcLarge: json['src_large'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'src': src,
      'src_small': srcSmall,
      'src_medium': srcMedium,
      'src_large': srcLarge,
    };
  }

  @override
  String toString(){
    return '''
      Image Data:
        Source: $src
        Source Small: $srcSmall
        Source Medium: $srcMedium
        Source Large: $srcLarge
    ''';
  }
}