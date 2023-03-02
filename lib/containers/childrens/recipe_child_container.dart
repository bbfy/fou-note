import 'package:custom_note/elements/child.dart';
import 'package:custom_note/elements/data_format.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';
import 'package:flutter/material.dart';
//element
import 'package:custom_note/elements/solo.dart';

// provider
import 'package:provider/provider.dart';

//dialog
import 'package:custom_note/dialogs/child/create_recipe_child.dart';
import 'package:custom_note/dialogs/child/update_recipe_child.dart';

class RecipeChildContainer extends StatefulWidget {
  final bool setting;
  final Solo recipe;
  final Size containerSize;
  const RecipeChildContainer(
      {Key? key,
      required this.recipe,
      required this.containerSize,
      required this.setting})
      : super(key: key);

  @override
  _RecipeChildContainerState createState() => _RecipeChildContainerState();
}

class _RecipeChildContainerState extends State<RecipeChildContainer> {
  late Solo recipe;
  late ColorScheme colorScheme;
  late Size containerSize;
  late Size ingredientSize;
  late Size processSize;

  List<String> subValueList = [];
  List<String> valueList = [];

  String subtrackSubValue(List<String> list, String subtrackValue,
      {int? index}) {
    String output = '';
    if (index != null) {
      list.removeAt(index);
    } else {
      list.removeAt(list.indexOf(subtrackValue));
    }
    int i = 0;
    for (String element in list) {
      if (i == list.length - 1) {
        output += element;
      } else {
        output += '$element\n';
      }
      i += 1;
    }
    return output;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recipe = widget.recipe;
    containerSize = widget.containerSize;
    ingredientSize = Size(containerSize.width, containerSize.height * 0.3);
    processSize = Size(containerSize.width, containerSize.height * 0.7);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    bool setting = widget.setting;
    Child child;
    List<Child> childList = context
        .watch<DbSqliteProvider>()
        .getChildList(ChildrenSort.recipeChild, recipe.id);

    if (childList.isEmpty) {
      child = Child(
          value: '',
          subValue: '',
          sort: ChildrenSort.recipeChild.name,
          motherId: recipe.id);
      context.read<DbSqliteProvider>().addChild(child);
    } else if (childList.length == 1) {
      child = childList[0];
    } else {
      child = childList[0];
      for (int i = 1; i < childList.length; i++) {
        context.read<DbSqliteProvider>().delChild(childList[i]);
      }
      childList.removeRange(1, childList.length - 1);
    }

    valueList = child.value.split('\n');
    subValueList = child.subValue.split('\n');

    return SizedBox(
        width: containerSize.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //ingredient
            SizedBox(
              width: ingredientSize.width,
              height: 50,
              child: Stack(
                children: [
                  Center(
                    child: Icon(recipeIconMap[RecipeSort.ingredient]),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CreateRecipeChildDialog(
                                child: child,
                                recipeSort: RecipeSort.ingredient),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: colorScheme.primary,
                        )),
                  )
                ],
              ),
            ),
            // ingredient list
            child.value == ''
                ? const SizedBox()
                : Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: valueList
                        .asMap()
                        .entries
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              setting
                                  ? showDialog(
                                      context: context,
                                      builder: (context) =>
                                          UpdateRecipeChildDialog(
                                              child: child,
                                              recipeSort: RecipeSort.ingredient,
                                              list: valueList,
                                              index: e.key))
                                  : () {};
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: setting
                                            ? colorScheme.primaryContainer
                                                .withOpacity(0.2)
                                            : null,
                                        border: Border.all(
                                            color: colorScheme.secondary),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      e.value,
                                      style: TextStyle(
                                          color: colorScheme.inverseSurface,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                                setting
                                    ? Positioned(
                                        top: 0,
                                        right: 1,
                                        width: 10,
                                        height: 17,
                                        child: IconButton(
                                            style: IconButton.styleFrom(
                                                minimumSize: const Size(15, 15),
                                                maximumSize:
                                                    const Size(15, 15)),
                                            padding: EdgeInsets.zero,
                                            // 누르면 제거
                                            onPressed: () {
                                              String output = subtrackSubValue(
                                                  valueList, e.value);
                                              child.value = output;
                                              context
                                                  .read<DbSqliteProvider>()
                                                  .updateChild(child);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: colorScheme.error
                                                  .withOpacity(0.9),
                                              size: 17,
                                            )))
                                    : const SizedBox()
                              ],
                            ),
                          ),
                        )
                        .toList()),
            const Divider(
              thickness: 1,
            ),
            // proecess
            SizedBox(
              width: processSize.width,
              height: 50,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(recipeIconMap[RecipeSort.process]),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => CreateRecipeChildDialog(
                                child: child, recipeSort: RecipeSort.process),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: colorScheme.primary,
                        )),
                  )
                ],
              ),
            ),
            child.subValue == ''
                ? const SizedBox()
                :
                //process list
                ListView.separated(
                    padding: const EdgeInsets.all(2),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 0.6,
                    ),
                    itemCount: subValueList.length,
                    itemBuilder: (context, index) => Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        //눌러서 수정
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => UpdateRecipeChildDialog(
                                    child: child,
                                    recipeSort: RecipeSort.process,
                                    list: subValueList,
                                    index: index));
                          },
                          child: Container(
                            decoration: setting
                                ? BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withOpacity(0.2),
                                    // borderRadius: BorderRadius.circular(12)
                                  )
                                : null,
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                      minHeight: 20, minWidth: 20),
                                  decoration: BoxDecoration(
                                      color:
                                          colorScheme.tertiary.withOpacity(0.5),
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.circular(90)),
                                  child: Center(
                                    child: Text(
                                      '$index',
                                      style: TextStyle(
                                          color: colorScheme.onTertiary),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(child: Text(subValueList[index])),
                                setting
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: IconButton(
                                            style: IconButton.styleFrom(
                                              padding: const EdgeInsets.all(2),
                                            ),
                                            //누르면 조리순서 삭제
                                            onPressed: () {
                                              String output = subtrackSubValue(
                                                  subValueList,
                                                  subValueList[index],
                                                  index: index);
                                              child.subValue = output;
                                              context
                                                  .read<DbSqliteProvider>()
                                                  .updateChild(child);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20,
                                              color: colorScheme.error
                                                  .withOpacity(0.9),
                                            )),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
