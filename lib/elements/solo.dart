import '../providers/db_format.dart';
import 'package:date_format/date_format.dart';

class Solo {
  // db VARIABLES
  int id;
  String sort;
  static int motherId = 0;
  String value;
  String subValue = '';
  late DateTime dt;
  String date;

  String dtToString() {
    return formatDate(dt, [yyyy, '-', mm, '-', dd]);
  }

  DateTime strToDt(String format) {
    return DateTime.parse(format);
  }

  Solo({this.id = 0, required this.sort, required this.value, this.date = ''}) {
    if (date == '') {
      dt = DateTime.now();
    } else {
      dt = strToDt(date);
    }
  }
  Solo.fromMap(Map<String, Object?> map)
      : this(
            id: map[DbFormats.id]! as int,
            sort: map[DbFormats.sort]! as String,
            value: map[DbFormats.value]! as String,
            date: map[DbFormats.date]! as String);

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
