import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// TODO: encapsulation

class Excercise {
  /// Excercise class that defines an excercise
  final String name;
  final ExcerciseType type;
  final BodyPart bodyPart;
  final String description;

  Excercise({
    required this.type,
    required this.bodyPart,
    required this.name,
    this.description = '',
  });

  Map<String, Object?> toJson() {
    return {
      'type': type.toShortString(),
      'bodyPart': bodyPart.toShortString(),
      'name': name,
      'description': description,
    };
  }

  Excercise.fromJson(Map<String, Object?> json)
      : type = ExcerciseType.none.fromString(json['type'] as String),
        bodyPart = BodyPart.none.fromString(json['bodyPart'] as String),
        name = json['name'] as String,
        description = json['description'] as String;

  toString() {
    return 'Excercise: $name, $type, $bodyPart, $description';
  }
}

class Log {
  final int? weight;
  final int? reps;
  final int? distance;
  final int? duration;
  final DateTime date;
  final String excerciseName;

  Log(
    this.weight,
    this.reps,
    this.date,
    this.excerciseName,
    this.distance,
    this.duration,
  );

  Map<String, Object?> toJson() {
    return {
      'weight': weight,
      'reps': reps,
      'date': date,
      'excerciseName': excerciseName,
      'distance': distance,
      'duration': duration,
    };
  }

  Log.fromJson(Map<String, Object?> json)
      : weight = json['weight'] as int?,
        reps = json['reps'] as int?,
        date = (json['date'] as Timestamp).toDate(),
        excerciseName = json['excerciseName'] as String,
        distance = json['distance'] as int?,
        duration = json['duration'] as int?;
}

enum ExcerciseType {
  cardio,
  strength,
  none,
}

enum BodyPart {
  chest,
  back,
  shoulders,
  arms,
  legs,
  abs,
  full,
  triceps,
  biceps,
  none,
}

extension ExcerciseString on ExcerciseType {
  String toShortString() {
    return this.toString().split('.').last;
  }

  ExcerciseType fromString(String type) {
    switch (type) {
      case 'cardio':
        return ExcerciseType.cardio;
      case 'strength':
        return ExcerciseType.strength;
      default:
        throw Exception('Invalid excercise type');
    }
  }
}

extension BodyString on BodyPart {
  String toShortString() {
    return this.toString().split('.').last;
  }

  BodyPart fromString(String part) {
    switch (part) {
      case 'chest':
        return BodyPart.chest;
      case 'back':
        return BodyPart.back;
      case 'shoulders':
        return BodyPart.shoulders;
      case 'arms':
        return BodyPart.arms;
      case 'legs':
        return BodyPart.legs;
      case 'abs':
        return BodyPart.abs;
      case 'full':
        return BodyPart.full;
      case 'triceps':
        return BodyPart.triceps;
      case 'biceps':
        return BodyPart.biceps;
      case 'none':
        return BodyPart.none;
      default:
        throw Exception('Invalid body part');
    }
  }
}
