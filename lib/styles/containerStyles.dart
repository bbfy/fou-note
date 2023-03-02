import 'package:custom_note/elements/solo.dart';
import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/soloProvider.dart';

//format
import 'package:custom_note/elements/data_format.dart';

//dialog
import 'package:custom_note/dialogs/solo/solo_dialog.dart';

class ContainerStyles {
  static double containerRadius = 12;
  static double height = 50;
  ColorScheme colorScheme;
  BuildContext context;
  Solo solo;
  ContainerStyles(
      {required this.colorScheme, required this.context, required this.solo});

  double getWidth() {
    return MediaQuery.of(context).size.width * 0.8;
  }

  dynamic getSoloUpdateDialog({required Solo solo}) {
    SoloSort soloSort = getSoloSort(solo);
    switch (soloSort) {
      case SoloSort.todo:
      case SoloSort.note:
      case SoloSort.recipe:
      case SoloSort.book:
        return UpdateSoloDialog(solo: solo);
    }
  }

  BoxDecoration getContainerDecoration() {
    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              colorScheme.primaryContainer,
              colorScheme.tertiaryContainer
            ]),
        borderRadius: BorderRadius.circular(containerRadius),
        color: colorScheme.onPrimaryContainer.withOpacity(0.4));
  }

  Widget getContainerIcon({required IconData iconData}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(
        iconData,
        color: colorScheme.primary,
        size: 30,
      ),
    );
  }

  Widget getContainerEditButton() {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => getSoloUpdateDialog(solo: solo),
          );
        },
        icon: Icon(
          Icons.edit,
          color: colorScheme.tertiary,
          size: 20,
        ));
  }

  Widget getContainerCheckBox(
      {required bool isChecked, required Function setState}) {
    return Checkbox(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          isChecked = !isChecked;
          context
              .read<SoloProvider>()
              .updateSoloCheck(solo: solo, check: value!);
        });
      },
    );
  }
}
