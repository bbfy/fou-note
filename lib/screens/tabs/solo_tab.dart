import 'package:flutter/material.dart';

//db
import 'package:custom_note/providers/db_sqlite_provider.dart';

//provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/soloProvider.dart';
import 'package:custom_note/providers/todo_provider.dart';
//elements
import 'package:custom_note/elements/solo.dart';

//dialog
import 'package:custom_note/dialogs/delete_dialog.dart';
import 'package:custom_note/dialogs/solo/solo_dialog.dart';
//data foramt
import 'package:custom_note/elements/data_format.dart';

//container
import 'package:custom_note/containers/solos/book_container.dart';
import 'package:custom_note/containers/solos/note_container.dart';
import 'package:custom_note/containers/solos/todo_container.dart';
import 'package:custom_note/containers/solos/recipe_container.dart';
import 'package:custom_note/containers/solos/checkedTodo_container.dart';

//styles
import 'tabStyles.dart';

//db
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SoloTab extends StatefulWidget {
  final SoloSort soloSort;
  const SoloTab({Key? key, required this.soloSort}) : super(key: key);

  @override
  _SoloTabState createState() => _SoloTabState();
}

class _SoloTabState extends State<SoloTab> {
  late SoloSort soloSort;
  bool checkBoxCheck = false;
  Size menuItemSize = const Size(100, 20);
  Size etcOneSize = const Size(70, 40);
  double checkedTodoContainerHeight = 150;

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    //테스트 용 배너 ca-app-pub-3940256099942544/6300978111
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',

    adUnitId: 'ca-app-pub-2039622419185808/2740270527',
    sizes: [AdSize.banner],
    request: const AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  )..load();

  @override
  void initState() {
    super.initState();
    context.read<DbSqliteProvider>().init();
  }

  dynamic getSoloCreateDialog({required SoloSort soloSort}) {
    switch (soloSort) {
      case SoloSort.todo:
      case SoloSort.note:
      case SoloSort.recipe:
      case SoloSort.book:
        return CreateSoloDialog(soloSort: soloSort);
    }
  }

  getSoloContainer(
      {required SoloSort sort,
      required Solo solo,
      required double listViewWidth}) {
    switch (sort) {
      case SoloSort.note:
        return NoteContainer(solo: solo, listViewWidth: listViewWidth);
      case SoloSort.todo:
        return TodoContainer(todo: solo, listViewWidth: listViewWidth);
      case SoloSort.recipe:
        return RecipeContainer(solo: solo, listViewWidth: listViewWidth);
      case SoloSort.book:
        return BookContainer(solo: solo, listViewWidth: listViewWidth);
    }
  }

  void addButtonOnPressed() {
    showDialog(
        context: context,
        builder: (context) {
          return getSoloCreateDialog(soloSort: soloSort);
        });
  }

  void chekBoxShowOnTap() {
    context.read<SoloProvider>().toggleCheckBoxShow();
  }

  void toggleAllOnTap() {
    context.read<SoloProvider>().setAllToggle(soloSort);
  }

  void deleteOnTap() {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
          element: context.read<SoloProvider>().getAllCheckedSoloList()),
    ).then((value) {
      context.read<SoloProvider>().setSortAllFalse(soloSort);
    });
  }

  @override
  Widget build(BuildContext context) {
    soloSort = widget.soloSort;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    TabStyles tabStyles = TabStyles(context: context, colorScheme: colorScheme);

    //size
    final Size screenSize = Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height -
            kBottomNavigationBarHeight -
            2 -
            50);

    final Size buttonContainerSize = Size(screenSize.width * 0.7, 100);
    final Size listViewSize = Size(screenSize.width * 0.8,
        screenSize.height - buttonContainerSize.height - AdSize.banner.height);

    //db
    final DbSqliteProvider dbWatch = context.watch<DbSqliteProvider>();
    List<Solo> soloList = dbWatch.getSoloList(soloSort);

    context.read<SoloProvider>().init(soloList);
    bool checkBoxShow = context.watch<SoloProvider>().getCheckBoxShow;
    List<Solo> checkedTodoList =
        context.watch<TodoProvider>().getCheckedTodoList;
    return SizedBox.expand(
      child: Column(
        children: [
          //statusbar 크기
          SizedBox(
            height: MediaQuery.of(context).viewPadding.top,
          ),
          Container(
            alignment: Alignment.center,
            width: AdSize.banner.width.toDouble(),
            height: AdSize.banner.height.toDouble(),
            child: AdWidget(
              ad: myBanner,
            ),
          ),
          SizedBox(
              width: listViewSize.width,
              height: listViewSize.height,
              child: Stack(
                children: [
                  Center(
                    child: tabStyles.getCenterIcon(soloIconMap[soloSort]!),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: soloSort == SoloSort.todo
                          ? listViewSize.height - checkedTodoContainerHeight
                          : null,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(5),
                        itemCount: soloList.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: getSoloContainer(
                                  sort: soloSort,
                                  solo: soloList[index],
                                  listViewWidth: listViewSize.width,
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                  //checked todo container
                  if (soloSort == SoloSort.todo)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomRight,
                                    end: Alignment.topLeft,
                                    colors: [
                                      colorScheme.primaryContainer,
                                      colorScheme.tertiaryContainer
                                    ]),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12)),
                                color: colorScheme.onPrimaryContainer
                                    .withOpacity(0.4)),
                            height: checkedTodoContainerHeight * 0.2,
                            width: listViewSize.width,
                            child: Align(
                              alignment: const Alignment(0.8, 0),
                              child: IconButton(
                                  padding: const EdgeInsets.all(2),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Center(
                                          child: Icon(
                                            Icons.restore_from_trash,
                                            size: 40,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Icon(Icons.close)),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                for (var todo
                                                    in checkedTodoList) {
                                                  context
                                                      .read<TodoProvider>()
                                                      .delTodoList(todo);
                                                  context
                                                      .read<DbSqliteProvider>()
                                                      .addSolo(todo);
                                                }
                                              },
                                              child: const Icon(Icons
                                                  .restore_from_trash_outlined)),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.restore_from_trash)),
                            ),
                          ),
                          Container(
                            width: listViewSize.width,
                            height: checkedTodoContainerHeight * 0.7,
                            decoration: BoxDecoration(
                                color: colorScheme.tertiaryContainer
                                    .withOpacity(0.2),
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: checkedTodoList.length,
                              itemBuilder: (context, index) => Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CheckedTodoContainer(
                                      todo: checkedTodoList[index],
                                      listViewWidth: listViewSize.width),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                ],
              )),
          //하단 기능
          SizedBox(
            width: buttonContainerSize.width,
            height: buttonContainerSize.height,
            child: Stack(
              children: [
                // 추가 버튼
                Align(
                    alignment: Alignment.center,
                    child: tabStyles.getFloatingButton(
                        addButtonOnPressed: addButtonOnPressed)),
                //기타 기능(선택, 데이터 추출 등)
                Align(
                  alignment: Alignment.centerRight,
                  child: tabStyles.getEtcPopupMenuButton(
                      enable: checkBoxShow,
                      chekBoxShowOnTap: chekBoxShowOnTap,
                      toggleAllOnTap: toggleAllOnTap,
                      deleteOnTap: deleteOnTap),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
