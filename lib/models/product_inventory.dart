class Inventory {

  final int? branchId;

  final int? batchId;

  final num? stockQuantity;

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

  Map<String, dynamic> toJson() {
    return {
      'id': branchId,
      'name': batchId,
      'slug': stockQuantity,
    };
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
