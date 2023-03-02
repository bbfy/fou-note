import 'package:custom_note/elements/data_format.dart';
import 'package:flutter/material.dart';

//elements
import 'package:custom_note/elements/solo.dart';

//styles
import 'package:custom_note/styles/dialogStyles.dart';

//db
import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';

class UpdateSoloDialog extends StatefulWidget {
  final Solo solo;
  const UpdateSoloDialog({Key? key, required this.solo}) : super(key: key);

  @override
  _UpdateSoloDialogState createState() => _UpdateSoloDialogState();
}

class _UpdateSoloDialogState extends State<UpdateSoloDialog> {
  TextEditingController textEditingController = TextEditingController();
  late Solo solo;
  late SoloSort soloSort;

  void updateSolo(String value) {
    solo.value = value;
    context.read<DbSqliteProvider>().updateSolo(solo);
  }

  void onPressed() {
    if (textEditingController.text.isEmpty) return;
    updateSolo(textEditingController.text);
    Navigator.of(context).pop();
  }

  void onSubmmited(String value) {
    if (value.isEmpty) return;
    updateSolo(value);
    Navigator.of(context).pop();
  }

  void onChanged(String value) {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    solo = widget.solo;
    soloSort = getSoloSort(solo);
    textEditingController.text = widget.solo.value;
    textEditingController.selection =
        TextSelection.collapsed(offset: widget.solo.value.length);
  }

  @override
  Widget build(BuildContext context) {
    DialogStyles dialogStyles = DialogStyles(context: context);

    return AlertDialog(
      content: Row(
        children: [
          dialogStyles.getSoloSortIcon(soloSort: soloSort),
          dialogStyles.getTextField(
              onChanged: onChanged,
              onSubmitted: onSubmmited,
              controller: textEditingController),
          dialogStyles.getAddIconButton(
              controller: textEditingController, onPressed: onPressed)
        ],
      ),
    );
  }
}
