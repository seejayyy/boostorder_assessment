// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as num,
      name: fields[1] as String,
      dateModified: fields[2] as String?,
      type: fields[3] as String,
      status: fields[4] as String,
      sku: fields[5] as String,
      regularPrice: fields[6] as String?,
      manageStock: fields[7] as bool,
      inStock: fields[8] as bool,
      dimensions: fields[9] as Dimensions,
      categories: (fields[10] as List).cast<Category>(),
      images: (fields[11] as List).cast<ImageData>(),
      variations: (fields[12] as List).cast<Variation>(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dateModified)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.sku)
      ..writeByte(6)
      ..write(obj.regularPrice)
      ..writeByte(7)
      ..write(obj.manageStock)
      ..writeByte(8)
      ..write(obj.inStock)
      ..writeByte(9)
      ..write(obj.dimensions)
      ..writeByte(10)
      ..write(obj.categories)
      ..writeByte(11)
      ..write(obj.images)
      ..writeByte(12)
      ..write(obj.variations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
