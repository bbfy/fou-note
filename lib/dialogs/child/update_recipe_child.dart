import 'package:custom_note/elements/child.dart';
import 'package:flutter/material.dart';

//element
import 'package:custom_note/elements/data_format.dart';

import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';
//style
import 'package:custom_note/styles/dialogStyles.dart';

class UpdateRecipeChildDialog extends StatefulWidget {
  final List<String> list;
  final int index;
  final Child child;
  final RecipeSort recipeSort;
  const UpdateRecipeChildDialog(
      {Key? key,
      required this.child,
      required this.recipeSort,
      required this.list,
      required this.index})
      : super(key: key);

  @override
  _UpdateRecipeChildDialogState createState() =>
      _UpdateRecipeChildDialogState();
}

class _UpdateRecipeChildDialogState extends State<UpdateRecipeChildDialog> {
  late Child child;
  late RecipeSort recipeSort;
  late List<String> list;
  late int index;
  late DialogStyles dialogStyles;
  TextEditingController textEditingController = TextEditingController();

  @override
  initState() {
    super.initState();
    child = widget.child;
    recipeSort = widget.recipeSort;
    list = widget.list;
    index = widget.index;
    textEditingController.text = list[index];
    textEditingController.selection =
        TextSelection.collapsed(offset: list[index].length);
    dialogStyles = DialogStyles(context: context);
  }

  void onChanged(String value) {
    setState(() {});
  }

  void onSubmitted(String value) {
    updateAndPop();
  }

  void updateAndPop() {
    if (textEditingController.text.isEmpty) return;
    changeChildValue(textEditingController);
    context.read<DbSqliteProvider>().updateChild(child);
    Navigator.of(context).pop();
  }

  void changeChildValue(TextEditingController controller) {
    String changeValue = controller.text;
    String output = '';
    list[index] = changeValue;

    int i = 0;
    for (String element in list) {
      if (i == list.length - 1) {
        output += element;
      } else {
        output += '$element\n';
      }
      i += 1;
    }
    if (recipeSort == RecipeSort.ingredient) {
      child.value = output;
    } else {
      child.subValue = output;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dialogStyles.getIcon(iconData: recipeIconMap[recipeSort]!),
          const SizedBox(
            width: 5,
          ),
          dialogStyles.getTextField(
              controller: textEditingController,
              onSubmitted: onSubmitted,
              onChanged: onChanged),
          dialogStyles.getAddIconButton(
              controller: textEditingController, onPressed: updateAndPop)
        ],
      ),
    );
  }
}
