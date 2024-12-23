class Inventory {

  final int? branchId;

  final int? batchId;

  final num? stockQuantity;

  final num? physicalStockQuantity;

  Inventory({
    required this.branchId,
    this.batchId,
    required this.stockQuantity,
    this.physicalStockQuantity,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      branchId: json['branch_id'],
      batchId: json['batch_id'],
      stockQuantity: json['stock_quantity'],
      physicalStockQuantity: json['physical_stock_quantity']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'batchId': batchId,
      'stockQuantity': stockQuantity,
      'physicalStockQuantity': physicalStockQuantity,
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
