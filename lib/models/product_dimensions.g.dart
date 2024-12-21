// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dimensions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DimensionsAdapter extends TypeAdapter<Dimensions> {
  @override
  final int typeId = 1;

  @override
  Dimensions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dimensions(
      height: fields[0] as String?,
      width: fields[1] as String?,
      length: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Dimensions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.height)
      ..writeByte(1)
      ..write(obj.width)
      ..writeByte(2)
      ..write(obj.length);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DimensionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
