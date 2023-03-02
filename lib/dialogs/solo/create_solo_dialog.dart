import 'package:custom_note/elements/solo.dart';
import 'package:flutter/material.dart';

//element
import 'package:custom_note/elements/data_format.dart';

//style
import 'package:custom_note/styles/dialogStyles.dart';

//db
import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';

class CreateSoloDialog extends StatefulWidget {
  final SoloSort soloSort;
  const CreateSoloDialog({Key? key, required this.soloSort}) : super(key: key);

  @override
  _CreateSoloDialogState createState() => _CreateSoloDialogState();
}

class _CreateSoloDialogState extends State<CreateSoloDialog> {
  late Solo solo;
  late DialogStyles dialogStyles;
  @override
  initState() {
    super.initState();
    solo = Solo(sort: widget.soloSort.name, value: '');
    dialogStyles = DialogStyles(context: context);
  }

  void addSolo(String value) {
    solo.value = value;
    context.read<DbSqliteProvider>().addSolo(solo);
  }

  void onPressed() {
    if (textEditingController.text.isEmpty) return;
    addSolo(textEditingController.text);
    Navigator.of(context).pop();
  }

  void onSubmmited(String value) {
    if (value.isEmpty) return;
    addSolo(value);
    Navigator.of(context).pop();
  }

  void onChanged(String value) {
    setState(() {});
  }

  String soloName = '';
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Size screenSize = MediaQuery.of(context).size;

    SoloSort soloSort = getSoloSort(solo);

    return AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dialogStyles.getSoloSortIcon(soloSort: soloSort),
          const SizedBox(
            width: 5,
          ),
          dialogStyles.getTextField(
            controller: textEditingController,
            onSubmitted: onSubmmited,
            onChanged: onChanged,
          ),
          dialogStyles.getAddIconButton(
              controller: textEditingController, onPressed: onPressed),
        ],
      ),
    );
  }
}
