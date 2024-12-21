import 'package:hive/hive.dart';

part 'product_inventory.g.dart';

@HiveType(typeId: 5)
class Inventory extends HiveObject {
  @HiveField(0)
  final num branchId;

  @HiveField(1)
  final num? batchId;

  @HiveField(2)
  final num stockQuantity;

  Inventory({
    required this.branchId,
    this.batchId,
    required this.stockQuantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      branchId: json['branch_id'],
      batchId: json['batch_id'],
      stockQuantity: json['stock_quantity'],
    );
  }

  @override
  String toString(){
    return '''
      Inventory:
        Branch ID: $branchId
        Batch ID: $batchId
        Stock Quantity: $stockQuantity
    ''';
  }
}
