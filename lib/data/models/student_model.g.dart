// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 0;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      randomId: fields[0] as String,
      surname: fields[1] as String,
      firstname: fields[2] as String,
      middlename: fields[3] as String,
      presentLevel: fields[4] as String,
      department: fields[5] as String,
      originalPassport: fields[6] as String,
      passport: fields[7] as String,
      cloudinaryUrl: fields[8] as String,
      status: fields[9] as int,
      schoolId: fields[10] as String?,
      studentNin: fields[11] as String?,
      ward: fields[12] as String?,
      gender: fields[13] as String?,
      dob: fields[14] as String?,
      nationality: fields[15] as String?,
      stateOfOrigin: fields[16] as String?,
      lga: fields[17] as String?,
      lgaOfEnrollment: fields[18] as String?,
      communityName: fields[19] as String?,
      residentialAddress: fields[20] as String?,
      yearOfEnrollment: fields[21] as String?,
      parentContact: fields[22] as String?,
      parentOccupation: fields[23] as String?,
      parentPhone: fields[24] as String?,
      parentName: fields[25] as String?,
      parentNin: fields[26] as String?,
      bankName: fields[27] as String?,
      accountNumber: fields[28] as String?,
      passcode: fields[29] as String?,
      createdBy: fields[30] as String?,
      parentBvn: fields[31] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.randomId)
      ..writeByte(1)
      ..write(obj.surname)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.middlename)
      ..writeByte(4)
      ..write(obj.presentLevel)
      ..writeByte(5)
      ..write(obj.department)
      ..writeByte(6)
      ..write(obj.originalPassport)
      ..writeByte(7)
      ..write(obj.passport)
      ..writeByte(8)
      ..write(obj.cloudinaryUrl)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.schoolId)
      ..writeByte(11)
      ..write(obj.studentNin)
      ..writeByte(12)
      ..write(obj.ward)
      ..writeByte(13)
      ..write(obj.gender)
      ..writeByte(14)
      ..write(obj.dob)
      ..writeByte(15)
      ..write(obj.nationality)
      ..writeByte(16)
      ..write(obj.stateOfOrigin)
      ..writeByte(17)
      ..write(obj.lga)
      ..writeByte(18)
      ..write(obj.lgaOfEnrollment)
      ..writeByte(19)
      ..write(obj.communityName)
      ..writeByte(20)
      ..write(obj.residentialAddress)
      ..writeByte(21)
      ..write(obj.yearOfEnrollment)
      ..writeByte(22)
      ..write(obj.parentContact)
      ..writeByte(23)
      ..write(obj.parentOccupation)
      ..writeByte(24)
      ..write(obj.parentPhone)
      ..writeByte(25)
      ..write(obj.parentName)
      ..writeByte(26)
      ..write(obj.parentNin)
      ..writeByte(27)
      ..write(obj.bankName)
      ..writeByte(28)
      ..write(obj.accountNumber)
      ..writeByte(29)
      ..write(obj.passcode)
      ..writeByte(30)
      ..write(obj.createdBy)
      ..writeByte(31)
      ..write(obj.parentBvn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
