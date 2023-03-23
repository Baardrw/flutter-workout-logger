class Tuple {
  final String string;
  final DateTime dateTime;

  Tuple(this.string, this.dateTime);

  Tuple.fromJson(Map<String, Object?> json)
      : string = json['string'] as String,
        dateTime = DateTime.fromMicrosecondsSinceEpoch(json['dateTime'] as int);

  Map<String, Object?> toJson() {
    return {
      'string': string,
      'dateTime': dateTime.microsecondsSinceEpoch,
    };
  }
}
