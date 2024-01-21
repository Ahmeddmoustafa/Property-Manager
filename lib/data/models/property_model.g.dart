// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyModelAdapter extends TypeAdapter<PropertyModel> {
  @override
  final int typeId = 1;

  @override
  PropertyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyModel(
      id: fields[6] as String,
      description: fields[0] as String,
      price: fields[1] as String,
      paid: fields[2] as String,
      buyerName: fields[3] as String,
      buyerNumber: fields[4] as String,
      installments: (fields[5] as List).cast<Installment>(),
    ).._type = fields[7] as String;
  }

  @override
  void write(BinaryWriter writer, PropertyModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.description)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.paid)
      ..writeByte(3)
      ..write(obj.buyerName)
      ..writeByte(4)
      ..write(obj.buyerNumber)
      ..writeByte(5)
      ..write(obj.installments)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj._type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InstallmentAdapter extends TypeAdapter<Installment> {
  @override
  final int typeId = 2;

  @override
  Installment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Installment(
      name: fields[0] as String,
      date: fields[1] as DateTime,
      amount: fields[2] as String,
    ).._type = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, Installment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj._type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstallmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
