// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_completion.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingCompletionAdapter extends TypeAdapter<PendingCompletion> {
  @override
  final int typeId = 1;

  @override
  PendingCompletion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingCompletion(
      habitId: fields[0] as String,
      date: fields[1] as String,
      status: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PendingCompletion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.habitId)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingCompletionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
