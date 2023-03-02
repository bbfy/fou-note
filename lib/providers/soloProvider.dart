import 'package:custom_note/elements/solo.dart';
import 'package:flutter/material.dart';

import 'package:custom_note/elements/data_format.dart';

class SoloProvider extends ChangeNotifier {
  bool inited = false;
  SoloProvider() {
    for (var element in SoloSort.values) {
      soloCheckMap[element] = {};
    }
  }
  bool checkBoxShow = false;
  bool allCheck = false;
  Map<SoloSort, Map<Solo, bool>> soloCheckMap = <SoloSort, Map<Solo, bool>>{};
  //sort 마다 체크박스를 보고 말고 구분
  // Map<SoloSort, bool> checkBoxShowMap = <SoloSort, bool>{};

  void init(List<Solo> soloList) {
    if (inited) return;
    if (soloList.isEmpty) return;
    SoloSort soloSort = getSoloSort(soloList[0]);
    for (var solo in soloList) {
      soloCheckMap[soloSort] = <Solo, bool>{};
      soloCheckMap[soloSort]!.addAll({solo: false});
    }
    inited = true;
  }

  void toggleCheckBoxShow() {
    checkBoxShow = !checkBoxShow;
    for (var soloSort in SoloSort.values) {
      setSortAllFalse(soloSort);
    }
    notifyListeners();
  }

  void updateCheckBoxShow(bool check) {
    checkBoxShow = check;
    for (var soloSort in SoloSort.values) {
      setSortAllFalse(soloSort);
    }
    notifyListeners();
  }

  void updateSoloCheck({required Solo solo, required bool check}) {
    SoloSort soloSort = getSoloSort(solo);
    soloCheckMap[soloSort]![solo] = check;
  }

  void setAllToggle(SoloSort soloSort) {
    if (soloCheckMap[soloSort]!.isEmpty) return;
    allCheck = !allCheck;
    soloCheckMap[soloSort]?.updateAll(
      (key, value) {
        return value = allCheck;
      },
    );

    notifyListeners();
  }

  void setSortAllFalse(SoloSort soloSort) {
    if (soloCheckMap[soloSort]!.isEmpty) return;
    soloCheckMap[soloSort]?.updateAll(
      (key, value) {
        return value = false;
      },
    );

    notifyListeners();
  }

  void setSortAllTrue(SoloSort soloSort) {
    if (soloCheckMap[soloSort]!.isEmpty) return;
    soloCheckMap[soloSort]!.updateAll(
      (key, value) {
        return value = true;
      },
    );
    notifyListeners();
  }

  bool getsoloCheck(Solo solo) {
    SoloSort soloSort = getSoloSort(solo);
    if (soloCheckMap[soloSort]![solo] == null) {
      soloCheckMap[soloSort]![solo] = false;
    }
    return soloCheckMap[soloSort]![solo]!;
  }

  List<Solo> getAllCheckedSoloList() {
    List<Solo> checkedList = <Solo>[];

    soloCheckMap.forEach((SoloSort soloSort, Map<Solo, bool> soloMap) {
      soloCheckMap[soloSort]?.forEach((Solo solo, bool check) {
        if (soloCheckMap[soloSort]?[solo] == true) {
          checkedList.add(solo);
        }
      });
    });
    return checkedList;
  }

  // solosort에서만 가져옴
  List<Solo> getSortCheckedSoloList(SoloSort soloSort) {
    List<Solo> checkedList = <Solo>[];

    soloCheckMap[soloSort]?.forEach((key, value) {
      if (soloCheckMap[soloSort]?[key] == true) {
        checkedList.add(key);
      }
    });
    return checkedList;
  }

  get getCheckBoxShow => checkBoxShow;
}
