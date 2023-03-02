import 'package:custom_note/elements/child.dart';
import 'package:flutter/material.dart';

//element

import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';

//styles
import 'package:custom_note/styles/dialogStyles.dart';

class UpdateBookChildDialog extends StatefulWidget {
  final Child child;
  const UpdateBookChildDialog({Key? key, required this.child})
      : super(key: key);

  @override
  _UpdateBookChildDialogState createState() => _UpdateBookChildDialogState();
}

class _UpdateBookChildDialogState extends State<UpdateBookChildDialog> {
  late Child child;
  late DialogStyles dialogStyles;

  void setChildValues() {
    child.value = valueEditingController.text;
    child.subValue = subValueEditingController.text;
  }

  void onChanged(String value) {
    setState(() {});
  }

  void onSubmitted(String value) {
    updateAndPop();
  }

  void updateAndPop() {
    if (valueEditingController.text.isEmpty) return;
    setChildValues();
    context.read<DbSqliteProvider>().updateChild(child);
    Navigator.of(context).pop();
  }

  void removeFocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  initState() {
    super.initState();
    child = widget.child;
    valueEditingController.text = child.value;
    valueEditingController.selection =
        TextSelection.collapsed(offset: child.value.length);
    subValueEditingController.text = child.subValue;
    subValueEditingController.selection =
        TextSelection.collapsed(offset: child.subValue.length);

    dialogStyles = DialogStyles(context: context);
  }

  IconData iconData = Icons.bookmark_border;
  IconData buttonIconData = Icons.bookmark_add_outlined;

  TextEditingController valueEditingController = TextEditingController();
  TextEditingController subValueEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
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
      actions: [
        dialogStyles.getAddIconButton(
            controller: valueEditingController,
            onPressed: updateAndPop,
            iconData: buttonIconData)
      ],
    );
  }
}
