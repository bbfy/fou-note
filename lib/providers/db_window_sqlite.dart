// import 'package:path/path.dart' as p;
//db
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite/sqflite.dart';

enum WindowDataSet { navi, note }

class DbWindowSqlite {
  // late Database db;
  // List<Navi> naviList = <Navi>[];
  // List<Note> noteList = <Note>[];

  // int naviId = 0;
  // int noteId = 0;

  // bool inited = false;

  // String table = 'Shelf';
  // String note = 'note';
  // String navi = 'navi';

  // Future<void> init() async {
  //   if (inited) return;

  //   String path = await databaseFactoryFfi.getDatabasesPath();

  //   path = p.join(path, 'shelf', 'shelf.db');
  //   db = await databaseFactoryFfi.openDatabase(path);
  //   await db.execute(
  //       'CREATE TABLE IF NOT EXISTS $table(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT NOT NULL, buyDate TEXT NOT NULL, deadLine TEXT NOT NULL)');

  //   inited = true;
  // }

  // String setString(WindowDataSet data) {
  //   switch (data) {
  //     case WindowDataSet.navi:
  //       return 'navi';
  //     case WindowDataSet.note:
  //       return 'note';
  //   }
  // }

  // // 테이블 안의 데이터 갯수
  // Future<int> getCount(WindowDataSet data) async {
  //   int? count;
  //   List<Map<String, Object?>> dataList;
  //   dataList = await db.rawQuery(
  //       'SELECT navi, COUNT(*) from $table GROUP BY ${setString(data)}');
  //   count = Sqflite.firstIntValue(dataList);
  //   return count ?? 0;
  // }

  // Future<List> getList(WindowDataSet data) async {
  //   naviList = <Navi>[];
  //   noteList = <Note>[];
  //   List<Map<String, Object?>> dataList;
  //   dataList = await db.query(table, groupBy: 'group=${setString(data)}');
  //   if (dataList.isNotEmpty) {
  //     for (var column in dataList) {
  //       if (data == WindowDataSet.navi) {
  //         Navi element = Navi.fromMap(column);
  //         naviList.add(element);
  //       } else {
  //         Note element = Note.fromMap(column);
  //         noteList.add(element);
  //       }
  //     }
  //   }
  //   if (data == WindowDataSet.navi) {
  //     return naviList;
  //   } else {
  //     return noteList;
  //   }
  // }

  // // 추가해야 id 기록
  // Future<void> add(WindowDataSet dataSet, var element) async {
  //   int id = await db.insert('Shelf', element.toJson());
  //   switch (dataSet) {
  //     case WindowDataSet.navi:
  //       element = element as Navi;
  //       naviList.add(element);
  //       naviList.last.id = id;
  //       break;
  //     case WindowDataSet.note:
  //       element = element as Note;
  //       noteList.add(element);
  //       noteList.last.id = id;
  //       break;
  //   }
  // }

  // Future<void> del(int id) async {
  //   await db.delete('Shelf', where: 'id = ?', whereArgs: [id]);
  // }

  // Future<void> update(int id, Map<String, Object?> data) async {
  //   await db.update('Shelf', data, where: 'id = ?', whereArgs: [id]);
  // }

  // Future<BrElement?> getElement(int id) async {
  //   List<Map<String, Object?>> map = await db.query('Shelf',
  //       // columns: ['id', 'title', 'description'], 전부 가져옴 일단
  //       where: 'id=?',
  //       whereArgs: [id]);
  //   if (map.isNotEmpty) {
  //     return BrElement.fromJson(map[0]);
  //   }
  // }
}
