import '../providers/db_format.dart';
import 'package:date_format/date_format.dart';

class Child {
  //검색용 id
  int id;
  String value;
  String subValue;
  late DateTime dt;
  String date;

  String sort;
  //몇 네비에 속하는지
  int motherId;
  String dtToString() {
    return formatDate(dt, [yyyy, '-', mm, '-', dd]);
  }

  DateTime strToDt(String format) {
    return DateTime.parse(format);
  }

  Child(
      {this.id = 0,
      required this.value,
      required this.subValue,
      required this.sort,
      required this.motherId,
      this.date = ''}) {
    if (date == '') {
      dt = DateTime.now();
    } else {
      dt = strToDt(date);
    }
  }
  Child.fromMap(Map<String, Object?> map)
      : this(
          id: map[DbFormats.id]! as int,
          value: map[DbFormats.value]! as String,
          subValue: map[DbFormats.subValue]! as String,
          sort: map[DbFormats.sort]! as String,
          motherId: map[DbFormats.motherId]! as int,
          date: map[DbFormats.date]! as String,
        );
  Map<String, Object?> toMap() {
    return {
      DbFormats.sort: sort,
      DbFormats.motherId: motherId,
      DbFormats.value: value,
      DbFormats.subValue: subValue,
      DbFormats.date: dtToString()
    };
  }
}
