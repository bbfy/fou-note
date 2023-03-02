import 'package:custom_note/elements/child.dart';
import 'package:flutter/material.dart';

class ChildProvider extends ChangeNotifier {
  bool inited = false;
  bool checkBoxShow = false;
  Map<Child, bool> childrenCheckMap = <Child, bool>{};
  bool allToggleValue = false;

  List<Child> getCheckedChildrenList() {
    List<Child> checkedChildrenList = <Child>[];
    childrenCheckMap.forEach((key, value) {
      if (value == true) {
        checkedChildrenList.add(key);
      }
    });
    return checkedChildrenList;
  }

  void init(List<Child> childrenList) {
    if (inited) return;
    for (var element in childrenList) {
      childrenCheckMap[element] = false;
    }
    inited = true;
  }

  void toggleCheckBoxShow() {
    checkBoxShow = !checkBoxShow;
    setAllFalse();
    notifyListeners();
  }

  void updateCheckBoxShow(bool check) {
    checkBoxShow = check;
    setAllFalse();
    notifyListeners();
  }

  void updateChildCheck({required Child child, required bool check}) {
    childrenCheckMap[child] = check;
  }

  void toggleAll() {
    allToggleValue = !allToggleValue;
    childrenCheckMap.updateAll(
      (key, value) {
        return value = allToggleValue;
      },
    );

    notifyListeners();
  }

  void setAllFalse() {
    childrenCheckMap.updateAll(
      (key, value) {
        return value = false;
      },
    );

    notifyListeners();
  }

  void setAllTrue() {
    childrenCheckMap.updateAll(
      (key, value) {
        return value = true;
      },
    );
    notifyListeners();
  }

  bool getChildCheck(Child child) {
    if (childrenCheckMap[child] == null) {
      childrenCheckMap[child] = false;
    }
    return childrenCheckMap[child]!;
  }

  get getCheckBoxShow => checkBoxShow;
}
