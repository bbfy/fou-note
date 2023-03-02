import 'package:custom_note/elements/child.dart';
import 'package:flutter/material.dart';

//element
import 'package:custom_note/elements/data_format.dart';

import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';

import 'package:custom_note/styles/dialogStyles.dart';

class CreateBookChildDialog extends StatefulWidget {
  final int motherId;
  const CreateBookChildDialog({Key? key, required this.motherId})
      : super(key: key);

  @override
  _CreateBookChildDialogState createState() => _CreateBookChildDialogState();
}

class _CreateBookChildDialogState extends State<CreateBookChildDialog> {
  late Child child;
  late int motherId;
  late DialogStyles dialogStyles;

  @override
  initState() {
    super.initState();
    motherId = widget.motherId;
    child = Child(
        value: '',
        subValue: '',
        sort: ChildrenSort.bookChild.name,
        motherId: motherId);

    dialogStyles = DialogStyles(context: context);
  }

  void setChildValues() {
    child.value = valueEditingController.text;
    child.subValue = subValueEditingController.text;
  }

  void onChanged(String value) {
    setState(() {});
  }

  void onSubmitted(String value) {
    addAndPop();
  }

  void addAndPop() {
    if (valueEditingController.text.isEmpty) return;
    setChildValues();
    context.read<DbSqliteProvider>().addChild(child);
    Navigator.of(context).pop();
  }

  void removeFocus() {
    FocusScope.of(context).unfocus();
  }

  IconData iconData = Icons.bookmark_border;
  IconData buttonIconData = Icons.bookmark_add_outlined;

  TextEditingController valueEditingController = TextEditingController();
  TextEditingController subValueEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dialogStyles.getIcon(iconData: iconData),

          const SizedBox(
            width: 5,
          ),

          // 페이지 입력 value
          dialogStyles.getTextField(
              controller: valueEditingController,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputType: TextInputType.number,
              textAlign: TextAlign.center),

          //메모입력장 subvalue
          dialogStyles.getTextField(
              controller: subValueEditingController,
              onSubmitted: (_) {
                removeFocus();
              },
              onChanged: onChanged),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        dialogStyles.getAddIconButton(
            controller: valueEditingController,
            onPressed: addAndPop,
            iconData: buttonIconData)
      ],
    );
  }
}
