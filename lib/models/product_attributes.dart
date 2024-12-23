enum AttributeType { parent, variation }

class Attributes {

  final int? id;
  final String? name;
  final String? slug;
  final int? position;
  final bool? visible;
  final bool? variation;
  final AttributeType? type;
  final List<String>? options; // For Parent Attributes
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