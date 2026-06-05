// lib/models/job_model.g.dart
// GENERATED CODE - Manually written for completeness

part of 'job_model.dart';

class JobAdapter extends TypeAdapter<Job> {
  @override
  final int typeId = 0;

  @override
  Job read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Job(
      id: fields[0] as String,
      title: fields[1] as String,
      company: fields[2] as String,
      location: fields[3] as String,
      employmentType: fields[4] as String,
      salaryRange: fields[5] as String,
      description: fields[6] as String,
      requiredSkills: (fields[7] as List).cast<String>(),
      logoUrl: fields[8] as String,
      postedDate: fields[9] as DateTime,
      isSaved: fields[10] as bool,
      viewCount: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Job obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.company)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.employmentType)
      ..writeByte(5)
      ..write(obj.salaryRange)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.requiredSkills)
      ..writeByte(8)
      ..write(obj.logoUrl)
      ..writeByte(9)
      ..write(obj.postedDate)
      ..writeByte(10)
      ..write(obj.isSaved)
      ..writeByte(11)
      ..write(obj.viewCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is JobAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}