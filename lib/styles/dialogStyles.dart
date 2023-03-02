import 'package:flutter/material.dart';

//element
import 'package:custom_note/elements/data_format.dart';
//db

class DialogStyles {
  final BuildContext context;

  DialogStyles({required this.context});

  final Map<SoloSort, IconData> iconList = {
    SoloSort.note: Icons.folder_outlined,
    SoloSort.todo: Icons.circle_outlined,
    SoloSort.book: Icons.book_outlined,
    SoloSort.recipe: Icons.cookie_outlined
  };

  Widget getIcon({required IconData iconData}) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          iconData,
          size: 28,
        ));
  }

  Widget getSoloSortIcon({required SoloSort soloSort}) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Icon(
        iconList[soloSort],
        size: 28,
      ),
    );
  }

  Widget getTextField({
    required TextEditingController controller,
    required void Function(String value) onSubmitted,
    required void Function(String value) onChanged,
    TextInputType? textInputType,
    TextAlign textAlign = TextAlign.start,
    bool autofocus = true,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.37,
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        autofocus: autofocus,
        keyboardType: textInputType,
        textAlign: textAlign,
      ),
    );
  }

  //값이 없으면 자동적으로 비활성화
  Widget getAddIconButton(
      {required TextEditingController controller,
      required void Function() onPressed,
      IconData? iconData}) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        iconData ?? Icons.add_box_rounded,
        color:
            controller.text.isEmpty ? colorScheme.outline : colorScheme.primary,
        size: 30,
      ),
    );
  }
}
