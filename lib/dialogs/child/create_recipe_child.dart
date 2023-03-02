import 'package:custom_note/elements/child.dart';
import 'package:flutter/material.dart';

//element
import 'package:custom_note/elements/data_format.dart';

import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';

//styles
import 'package:custom_note/styles/dialogStyles.dart';

class CreateRecipeChildDialog extends StatefulWidget {
  final Child child;
  final RecipeSort recipeSort;
  const CreateRecipeChildDialog(
      {Key? key, required this.child, required this.recipeSort})
      : super(key: key);

  @override
  _CreateRecipeChildDialogState createState() =>
      _CreateRecipeChildDialogState();
}

class _CreateRecipeChildDialogState extends State<CreateRecipeChildDialog> {
  late Child child;
  late RecipeSort recipeSort;
  late DialogStyles dialogStyles;
  final TextEditingController valueEditingController = TextEditingController();

  @override
  initState() {
    super.initState();
    child = widget.child;
    recipeSort = widget.recipeSort;
    dialogStyles = DialogStyles(context: context);
  }

  void onChanged(String value) {
    setState(() {});
  }

  void onSubmitted(String value) {
    updateAndPop();
  }

  void updateAndPop() {
    if (valueEditingController.text.isEmpty) return;
    childAddValue(valueEditingController);
    context.read<DbSqliteProvider>().updateChild(child);
    Navigator.of(context).pop();
  }

  void childAddValue(TextEditingController controller) {
    String value = controller.text;
    if (recipeSort == RecipeSort.ingredient) {
      String addValue = child.value.isEmpty ? value : '\n$value';
      child.value += addValue;
    } else {
      String addValue = child.subValue.isEmpty ? value : '\n$value';
      child.subValue += addValue;
    }
  }

  Map<RecipeSort, IconData> iconMap = {
    RecipeSort.ingredient: Icons.kitchen,
    RecipeSort.process: Icons.soup_kitchen,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          dialogStyles.getIcon(iconData: iconMap[recipeSort]!),
          const SizedBox(
            width: 5,
          ),
          dialogStyles.getTextField(
              controller: valueEditingController,
              onSubmitted: onSubmitted,
              onChanged: onChanged),
          dialogStyles.getAddIconButton(
              controller: valueEditingController, onPressed: updateAndPop)
        ],
      ),
    );
  }
}
