import 'package:flutter/material.dart';

//db
import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';
//dataformat
// import 'package:custom_note/elements/data_format.dart';

//element
import 'package:custom_note/elements/child.dart';
import 'package:custom_note/elements/solo.dart';

class DeleteDialog extends StatelessWidget {
  final dynamic element;
  const DeleteDialog({Key? key, required this.element}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DbSqliteProvider dbRead = context.read<DbSqliteProvider>();
    return AlertDialog(
      title: const Center(
        child: Icon(Icons.delete_outline, size: 50),
      ),
      actions: [
        //취소
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.close),
        ),
        //삭제
        TextButton(
          onPressed: () {
            //추가 누르면 실행
            if (element is List<Solo>) {
              for (Solo solo in (element as List<Solo>)) {
                dbRead.delSolo(solo);
              }
            } else if (element is List<Child>) {
              for (Child child in (element as List<Child>)) {
                dbRead.delChild(child);
              }
            }
            if (element.runtimeType == Solo) {
              dbRead.delSolo(element);
            } else if (element.runtimeType == Child) {
              dbRead.delChild(element);
            }

            Navigator.of(context).pop();
          },
          child: const Icon(Icons.delete),
        ),
      ],
    );
  }
}
