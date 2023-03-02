import 'package:custom_note/elements/data_format.dart';
import 'package:flutter/material.dart';
//element
import 'package:custom_note/elements/solo.dart';

// provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/soloProvider.dart';

import 'package:custom_note/styles/containerStyles.dart';

//dialog

import 'package:custom_note/containers/childrens/recipe_child_container.dart';

class RecipeContainer extends StatefulWidget {
  final Solo solo;
  final double listViewWidth;

  const RecipeContainer(
      {Key? key, required this.solo, required this.listViewWidth})
      : super(key: key);

  @override
  _RecipeContainerState createState() => _RecipeContainerState();
}

class _RecipeContainerState extends State<RecipeContainer> {
  //펼쳐
  bool fold = false;
  bool setting = false;
  late Solo recipe;
  late double listViewWidth;
  late Size containerSize;
  late Size motherContainerSize;
  late Size childContainerSize;

  @override
  void initState() {
    super.initState();
    recipe = widget.solo;

    listViewWidth = widget.listViewWidth;
    containerSize = Size(widget.listViewWidth * 0.85, 200);
    motherContainerSize = Size(widget.listViewWidth * 0.85, 50);
    childContainerSize = Size(widget.listViewWidth * 0.85,
        containerSize.height - motherContainerSize.height);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool checkBoxShow = context.watch<SoloProvider>().getCheckBoxShow;
    bool isChecked = context.watch<SoloProvider>().getsoloCheck(recipe);
    ContainerStyles containerStyles = ContainerStyles(
        colorScheme: colorScheme, context: context, solo: recipe);

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
          gradient: fold
              ? LinearGradient(
                  begin: const Alignment(0, -1),
                  end: const Alignment(0, 1),
                  colors: [
                      colorScheme.tertiaryContainer
                          .withRed(250)
                          .withOpacity(0.5),
                      colorScheme.primaryContainer.withOpacity(0.5),
                    ])
              : LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                      colorScheme.tertiaryContainer,
                      colorScheme.primaryContainer,
                    ]),
          borderRadius: BorderRadius.circular(12),
          color: colorScheme.primaryContainer.withOpacity(0.4)),
      width: containerSize.width,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                fold = !fold;
              });
            },
            child: Stack(
              children: [
                SizedBox(
                  width: motherContainerSize.width,
                  height: motherContainerSize.height,
                  child: Row(
                    children: [
                      //체크박스
                      if (checkBoxShow)
                        containerStyles.getContainerCheckBox(
                            isChecked: isChecked, setState: setState),

                      // 아이콘
                      containerStyles.getContainerIcon(
                          iconData: soloIconMap[getSoloSort(recipe)]!),

                      // 이름 표시 text
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Text(
                          recipe.value,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: colorScheme.inverseSurface, fontSize: 13),
                        ),
                      )),
                      //setting
                      fold
                          ? IconButton(
                              padding: const EdgeInsets.all(4),
                              onPressed: () {
                                setState(() {
                                  setting = !setting;
                                });
                              },
                              icon: Icon(
                                Icons.settings,
                                color: setting ? colorScheme.error : null,
                              ))
                          : const SizedBox(),

                      //수정 버튼
                      containerStyles.getContainerEditButton(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child:
                      Icon(fold ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                )
              ],
            ),
          ),
          fold
              ? RecipeChildContainer(
                  recipe: recipe,
                  containerSize: childContainerSize,
                  setting: setting,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
