// lib/models/application_model.g.dart
// GENERATED CODE - Manually written for completeness

part of 'application_model.dart';

class JobApplicationAdapter extends TypeAdapter<JobApplication> {
  @override
  final int typeId = 2;

  @override
  JobApplication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JobApplication(
      id: fields[0] as String,
      jobId: fields[1] as String,
      jobTitle: fields[2] as String,
      company: fields[3] as String,
      status: fields[4] as String,
      appliedDate: fields[5] as DateTime,
      updatedDate: fields[6] as DateTime,
      notes: fields[7] as String,
      synced: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, JobApplication obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jobId)
      ..writeByte(2)
      ..write(obj.jobTitle)
      ..writeByte(3)
      ..write(obj.company)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.appliedDate)
      ..writeByte(6)
      ..write(obj.updatedDate)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobApplicationAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}