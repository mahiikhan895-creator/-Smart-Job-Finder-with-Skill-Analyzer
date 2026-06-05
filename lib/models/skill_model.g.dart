// lib/models/skill_model.g.dart
// GENERATED CODE - Manually written for completeness

part of 'skill_model.dart';

class SkillAdapter extends TypeAdapter<Skill> {
  @override
  final int typeId = 1;

  @override
  Skill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Skill(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      recommendedCourse: fields[3] as String,
      difficultyLevel: fields[4] as String,
      courseUrl: fields[5] as String,
      provider: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Skill obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.recommendedCourse)
      ..writeByte(4)
      ..write(obj.difficultyLevel)
      ..writeByte(5)
      ..write(obj.courseUrl)
      ..writeByte(6)
      ..write(obj.provider);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SkillAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}