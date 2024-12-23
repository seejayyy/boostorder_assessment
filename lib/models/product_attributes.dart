import 'package:hive/hive.dart';

part 'product_attributes.g.dart';

enum AttributeType { parent, variation }

@HiveType(typeId: 1)
class Attributes extends HiveObject{
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String slug;

  @HiveField(3)
  final int? position;

  @HiveField(4)
  final bool? visible;

  @HiveField(5)
  final bool? variation;

  @HiveField(6)
  final AttributeType type;

  @HiveField(7)
  final List<String>? options; // For Parent Attributes

  @HiveField(8)
  final String? option;

  Attributes({
    required this.id,
    required this.name,
    required this.slug,
    this.position,
    required this.visible,
    required this.variation,
    required this.type,
    this.options,
    this.option,
  });


  factory Attributes.fromJson(Map<String, dynamic> json, AttributeType type) {
    return Attributes(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      position: type == AttributeType.parent ? json['position'] : null,
      visible: type == AttributeType.parent ? json['visible'] : null,
      variation: type == AttributeType.parent ? json['variation'] : null,
      type: type,
      options: type == AttributeType.parent
          ? List<String>.from(json['options'] ?? [])
          : null,
      option: type == AttributeType.variation ? json['option'] : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'position': position,
      'visible': visible,
      'variation': variation,
      'type': type.toString(),
      if (options != null) 'options': options,
      if (option != null) 'option': option,
    };
  }

  @override
  String toString(){
    return '''
      Variation:
        ID: $id
        Name: $name
        Slug: $slug
        Position: $position
        Visible: $visible
        Variation: $variation
        Type: $type
        Options: $options
        Option: $option
    ''';
  }
}