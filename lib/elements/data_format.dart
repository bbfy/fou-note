//DB SORTS
import 'package:custom_note/elements/child.dart';
import 'package:custom_note/elements/solo.dart';

import 'package:flutter/material.dart';

// icons
Map<SoloSort, IconData> soloIconMap = {
  SoloSort.note: Icons.description_outlined,
  SoloSort.todo: Icons.check_circle_outline_rounded,
  SoloSort.book: Icons.book_outlined,
  SoloSort.recipe: Icons.cookie_outlined
};
Map<RecipeSort, IconData> recipeIconMap = {
  RecipeSort.ingredient: Icons.kitchen,
  RecipeSort.process: Icons.soup_kitchen,
};
// db 정리

enum SoloSort { note, todo, book, recipe }

enum ChildrenSort { noteChild, recipeChild, bookChild }

enum RecipeSort { ingredient, process }

Map<SoloSort, ChildrenSort> motherChildrenMap = {
  SoloSort.note: ChildrenSort.noteChild,
  SoloSort.recipe: ChildrenSort.recipeChild,
  SoloSort.book: ChildrenSort.bookChild
};
Map<ChildrenSort, SoloSort> childrenMotherMap = {
  ChildrenSort.noteChild: SoloSort.note,
  ChildrenSort.recipeChild: SoloSort.recipe,
  ChildrenSort.bookChild: SoloSort.book
};

SoloSort getSoloSort(Solo solo) {
  return SoloSort.values.where((element) => element.name == solo.sort).first;
}

ChildrenSort getChildrenSort(Child child) {
  return ChildrenSort.values
      .where((element) => element.name == child.sort)
      .first;
}

bool isMotherSort(SoloSort soloSort) {
  return (soloSort == SoloSort.note || soloSort == SoloSort.recipe);
}
