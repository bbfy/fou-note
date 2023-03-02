import 'package:flutter/material.dart';

import 'package:custom_note/providers/db_sqlite_provider.dart';

import 'package:provider/provider.dart';

import 'package:custom_note/elements/data_format.dart';
import 'package:custom_note/elements/child.dart';

import 'package:custom_note/containers/etc/draw_widget.dart';

import 'package:custom_note/styles/dialogStyles.dart';

class CreateNoteChildDialog extends StatefulWidget {
  final int motherId;
  const CreateNoteChildDialog({Key? key, required this.motherId})
      : super(key: key);

  @override
  _CreateNoteChildDialogState createState() => _CreateNoteChildDialogState();
}

class _CreateNoteChildDialogState extends State<CreateNoteChildDialog> {
  ChildrenSort noteChildSort = ChildrenSort.noteChild;
  late DialogStyles dialogStyles;
  late Child noteChild;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dialogStyles = DialogStyles(context: context);
    noteChild = Child(
        sort: noteChildSort.name,
        motherId: widget.motherId,
        value: '',
        subValue: '');
  }

  void onChange() {
    setState(() {});
  }

  void onPressed() {
    if (textEditingController.text.isEmpty) return;
    context.read<DbSqliteProvider>().addChild(noteChild);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Size containerSize = MediaQuery.of(context).size;

    Size fieldSize = Size(containerSize.width, containerSize.height * 0.5);

    // ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      // title: const Text('메모 추가'),
      content: DrawWidget(
        noteChild: noteChild,
        fieldSize: fieldSize,
        controller: textEditingController,
        onChange: onChange,
      ),

      actions: [
        SizedBox(
            width: 300,
            child: dialogStyles.getAddIconButton(
                controller: textEditingController,
                onPressed: onPressed,
                iconData: Icons.note_add_outlined))
      ],
    );
  }
}
