import 'package:hive/hive.dart';

part 'product_category.g.dart';

@HiveType(typeId: 2) // Unique typeId for Category
class Category extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int parentId;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final bool indirect;

  Category({
    required this.id,
    required this.parentId,
    required this.name,
    required this.indirect,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      parentId: json['parent_id'],
      name: json['name'],
      indirect: json['indirect'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'name': name,
      'indirect': indirect,
    };
  }

  @override
  String toString(){
    return '''
      Category:
        ID: $id
        Name: $name
        Parent ID: $parentId
        Indirect: $indirect
    ''';
  }
}
