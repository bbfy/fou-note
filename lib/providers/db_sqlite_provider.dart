import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

//import all element
import 'package:custom_note/elements/solo.dart';
import 'package:custom_note/elements/child.dart';

//db
import 'package:sqflite/sqflite.dart';
//foramt
import '../elements/data_format.dart';
import 'db_format.dart';

class DbSqliteProvider extends ChangeNotifier {
  late Database db;

  //solo child map
  Map<SoloSort, List<Solo>> solosMap = <SoloSort, List<Solo>>{};

  // motherSort -> motherId -> child list
  Map<ChildrenSort, Map<int, List<Child>>> childrenMap =
      <ChildrenSort, Map<int, List<Child>>>{};

  // 초기화 여부
  bool inited = false;

  //getter
  List<Solo> getSoloList(SoloSort soloSort) {
    if (solosMap[soloSort] == null) {
      solosMap[soloSort] = <Solo>[];
    }
    return solosMap[soloSort]!;
  }

  List<Child> getChildList(ChildrenSort childrens, int motherInt) {
    if (childrenMap[childrens]![motherInt] == null) {
      childrenMap[childrens]![motherInt] = <Child>[];
    }

    return childrenMap[childrens]![motherInt]!;
  }

  // db functions
  Future init() async {
    if (inited) return false;
    inited = true;
    String path = await getDatabasesPath();
    path = p.join(path, DbFormats.table, '${DbFormats.table}.db');

    db = await openDatabase(path);
    // await db.execute('DROP TABLE ${DbFormats.table}');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS ${DbFormats.table}(${DbFormats.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, ${DbFormats.sort} TEXT NOT NULL, ${DbFormats.value} TEXT NOT NULL, ${DbFormats.subValue} TEXT NOT NULL, ${DbFormats.motherId} INTEGER NOT NULL, ${DbFormats.date} TEXT NOT NULL )');
    await initSolos().then((value) => initChildren());
  }

  // solo list 연결
  Future<void> initSolos() async {
    for (SoloSort solos in SoloSort.values) {
      solosMap[solos] = <Solo>[];

      //자식 init
      ChildrenSort? childrenSort = motherChildrenMap[solos];
      if (childrenSort != null) {
        childrenMap[childrenSort] = <int, List<Child>>{};
      }

      List<Map<String, Object?>> dataList;
      dataList = await db.query(DbFormats.table,
          where: '${DbFormats.sort}=?', whereArgs: [solos.name]);
      if (dataList.isNotEmpty) {
        for (Map<String, Object?> map in dataList) {
          solosMap[solos]!.add(Solo.fromMap(map));

          childrenMap[childrenSort]?[map[DbFormats.id] as int] = <Child>[];
        }
      }
    }
    notifyListeners();
  }

  // children list 연결
  Future<void> initChildren() async {
    for (ChildrenSort child in ChildrenSort.values) {
      if (child == ChildrenSort.recipeChild) {}
      SoloSort motherSort = childrenMotherMap[child]!;

      List<int> motherIdList = solosMap[motherSort]!.map((e) => e.id).toList();

      List<Map<String, Object?>> dataList;

      dataList = await db.query(DbFormats.table,
          where: '${DbFormats.sort}=?', whereArgs: [child.name]);
      if (dataList.isNotEmpty) {
        for (Map<String, Object?> map in dataList) {
          bool haveMother = false;
          int savedMotherId = map[DbFormats.motherId] as int;
          motherIdList.forEach((element) {
            if (element == savedMotherId) {
              haveMother = true;
              childrenMap[child]![element]!.add(Child.fromMap(map));
            }
          });
          if (haveMother == false) {
            delId(map[DbFormats.id] as int);
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> delId(int id) async {
    await db.delete(DbFormats.table,
        where: '${DbFormats.id} = ?', whereArgs: ['$id']);
  }

  Future<void> addSolo(Solo solo) async {
    SoloSort soloSort = getSoloSort(solo);

    int id = await db.insert('Shelf', solo.toMap());

    //리스트에 추가
    solo.id = id;
    solosMap[soloSort]!.add(solo);
    if (isMotherSort(soloSort)) {
      ChildrenSort childrenSort = motherChildrenMap[soloSort]!;
      childrenMap[childrenSort] = <int, List<Child>>{};
      childrenMap[childrenSort]![solo.id] = <Child>[];
    }
    notifyListeners();
  }

  Future<void> updateSolo(Solo solo) async {
    SoloSort soloSort = getSoloSort(solo);
    await db
        .update('Shelf', solo.toMap(), where: 'id = ?', whereArgs: [solo.id]);
    //리스트 변경
    int soloIndex =
        solosMap[soloSort]!.indexWhere((element) => element.id == solo.id);
    //발견 안되면
    if (soloIndex == -1) {}
    solosMap[soloSort]![soloIndex] = solo;
    notifyListeners();
  }

  Future<void> delSolo(Solo solo) async {
    SoloSort soloSort = getSoloSort(solo);
    await db.delete(DbFormats.table,
        where: '${DbFormats.id} = ?', whereArgs: ['${solo.id}']);
    await db.delete(DbFormats.table,
        where: '${DbFormats.motherId} = ?', whereArgs: ['${solo.id}']);

    //리스트에서 삭제
    solosMap[soloSort]!.removeWhere(((element) => element.id == solo.id));
    bool isMother = isMotherSort(soloSort);
    if (isMother) {
      ChildrenSort childrenSort = motherChildrenMap[soloSort]!;
      childrenMap[childrenSort]!.removeWhere(
        (key, value) => key == solo.id,
      );
    }
    notifyListeners();
  }

  // note 추가
  Future<void> addChild(Child child) async {
    ChildrenSort childrenSort = getChildrenSort(child);
    int id = await db.insert('Shelf', child.toMap());
    //리스트에 추가
    child.id = id;
    if (childrenMap[childrenSort]![child.motherId] == null) {
      childrenMap[childrenSort]![child.motherId] = <Child>[];
    }
    childrenMap[childrenSort]![child.motherId]!.add(child);
    notifyListeners();
  }

  Future<void> updateChild(Child child) async {
    ChildrenSort childrenSort = getChildrenSort(child);
    await db
        .update('Shelf', child.toMap(), where: 'id = ?', whereArgs: [child.id]);
    //리스트 변경
    List<Child> childList =
        childrenMap[childrenSort]![child.motherId] as List<Child>;
    childrenMap[childrenSort]![child.motherId]![
        childList.indexWhere((element) => element.id == child.id)] = child;
    notifyListeners();
  }

  Future<void> delChild(Child child) async {
    ChildrenSort childrenSort = getChildrenSort(child);
    await db.delete('Shelf', where: 'id = ?', whereArgs: [child.id]);
    //리스트에서 삭제
    if (childrenMap[childrenSort] == null) {
      return;
    }

    childrenMap[childrenSort]![child.motherId]!.removeWhere(
      (element) {
        return element.id == child.id;
      },
    );
    notifyListeners();
  }

  // // 테이블 안의 데이터 갯수 리턴
  // Future<int> getCount(String groupName) async {
  //   int? count;
  //   List<Map<String, Object?>> dataList;
  //   dataList =
  //       await db.rawQuery('SELECT COUNT(*) from $table GROUP BY $groupName');
  //   count = Sqflite.firstIntValue(dataList);
  //   return count ?? 0;
  // }
  // Future<List> getAll() async {
  //   allList = <Map<String, Object?>>[];
  //   allList = await db.query(table);
  //   print('모든 데이터 로드');
  //   print(allList);
  //   print(allList.runtimeType);
  //   return allList;
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
