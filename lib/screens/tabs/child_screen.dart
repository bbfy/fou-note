import 'package:custom_note/elements/data_format.dart';
// import 'package:custom_note/containers/childrens/children_container.dart';
import 'package:flutter/material.dart';
//elements
import 'package:custom_note/elements/solo.dart';
import 'package:custom_note/elements/child.dart';

//child container
import 'package:custom_note/containers/childrens/note_child_container.dart';

//db
//provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';
import 'package:custom_note/providers/childProvider.dart';

//dialog
import 'package:custom_note/dialogs/delete_dialog.dart';
import 'package:custom_note/dialogs/child/create_note_child_dialog.dart';

//styles
import 'tabStyles.dart';

//ad
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChildScreen extends StatefulWidget {
  final Solo mother;
  const ChildScreen({Key? key, required this.mother}) : super(key: key);

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  Size etcOneSize = const Size(70, 40);
  late Solo mother;
  late SoloSort motherSort;
  late ChildrenSort childrenSort;
  //밑에 조금 띄우려고
  double bottomVaccum = 50;

  final AdManagerBannerAd myBanner = AdManagerBannerAd(
    //테스트 용 배너 ca-app-pub-3940256099942544/6300978111
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',

    adUnitId: 'ca-app-pub-2039622419185808/2740270527',
    sizes: [AdSize.banner],
    request: const AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(),
  )..load();
  final AdManagerBannerAd myBanner2 = AdManagerBannerAd(
    //테스트 용 배너 ca-app-pub-3940256099942544/6300978111
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',

    adUnitId: 'ca-app-pub-2039622419185808/7652867613',
    sizes: [AdSize.banner],
    request: const AdManagerAdRequest(),
    listener: AdManagerBannerAdListener(
      onAdLoaded: (ad) {},
      onAdOpened: (ad) {},
      onAdImpression: (ad) {},
    ),
  )..load();
  @override
  initState() {
    super.initState();
    mother = widget.mother;
    motherSort = getSoloSort(mother);
    childrenSort = motherChildrenMap[motherSort]!;
  }

  getChildContainer(SoloSort motherSort, Child child, double listViewWidth) {
    switch (motherSort) {
      case SoloSort.note:
        return NoteChildContainer(
          child: child,
          listViewWidth: listViewWidth,
        );
      case SoloSort.recipe:
      case SoloSort.todo:
      case SoloSort.book:
        break;
    }
  }

  Map<SoloSort, IconData> iconMap = {
    SoloSort.note: Icons.description_outlined,
    SoloSort.recipe: Icons.cookie_outlined
  };

  void addButtonOnPressed() {
    showDialog(
        context: context,
        builder: (context) => CreateNoteChildDialog(motherId: mother.id));
  }

  void chekBoxShowOnTap() {
    context.read<ChildProvider>().toggleCheckBoxShow();
  }

  void toggleAllOnTap() {
    context.read<ChildProvider>().toggleAll();
  }

  void deleteOnTap() {
    showDialog(
      context: context,
      builder: (context) => DeleteDialog(
          element: context.read<ChildProvider>().getCheckedChildrenList()),
    ).then((value) {
      context.read<ChildProvider>().setAllFalse();
    });
  }

  @override
  Widget build(BuildContext context) {
    //styles
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TabStyles tabStyles =
        TabStyles(context: context, colorScheme: colorScheme);

    //screen size
    final Size screenSize = Size(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    final Size bodySize =
        Size(screenSize.width, screenSize.height - kToolbarHeight);

    // column child sizes
    final Size buttonContainerSize = Size(bodySize.width * 0.7, 100);
    final Size listViewSize = Size(
        bodySize.width * 0.8,
        bodySize.height -
            buttonContainerSize.height -
            2 * AdSize.banner.height -
            34);

    //child datas
    List<Child> childList =
        context.watch<DbSqliteProvider>().getChildList(childrenSort, mother.id);

    //check box
    context.read<ChildProvider>().init(childList);
    bool checkBoxShow = context.watch<ChildProvider>().getCheckBoxShow;

    return Scaffold(
        appBar: AppBar(),
        body: SizedBox(
          width: bodySize.width,
          height: bodySize.height,
          child: Stack(
            children: [
              Align(
                  alignment: const Alignment(0, -0.2),
                  child: tabStyles.getCenterIcon(iconMap[motherSort]!)),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: AdSize.banner.width.toDouble(),
                      height: AdSize.banner.height.toDouble(),
                      child: AdWidget(
                        ad: myBanner,
                      ),
                    ),
                    // 자식 컨테이너 모음
                    SizedBox(
                      width: listViewSize.width,
                      height: listViewSize.height,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(15),
                        itemCount: childList.length,
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: getChildContainer(
                                  SoloSort.values.byName(mother.sort),
                                  childList[index],
                                  listViewSize.height),
                            ),
                          );
                        },
                      ),
                    ),
                    //하단
                    SizedBox(
                      width: buttonContainerSize.width,
                      height: buttonContainerSize.height,
                      child: Stack(
                        children: [
                          //추가 버튼
                          Align(
                            alignment: Alignment.center,
                            child: tabStyles.getFloatingButton(
                                addButtonOnPressed: addButtonOnPressed),
                          ),

                          //기타 기능(선택, 데이터 추출 등)
                          Align(
                            alignment: Alignment.centerRight,
                            child: tabStyles.getEtcPopupMenuButton(
                                enable: checkBoxShow,
                                chekBoxShowOnTap: chekBoxShowOnTap,
                                toggleAllOnTap: toggleAllOnTap,
                                deleteOnTap: deleteOnTap),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: AdSize.banner.width.toDouble(),
                      height: AdSize.banner.height.toDouble(),
                      child: AdWidget(
                        ad: myBanner2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
