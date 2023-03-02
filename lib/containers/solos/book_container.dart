import 'package:flutter/material.dart';

// provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/soloProvider.dart';

//elements
import 'package:custom_note/elements/solo.dart';
//style
import 'package:custom_note/styles/containerStyles.dart';

//dialog
import 'package:custom_note/dialogs/child/create_book_child_dialog.dart';

//child
import 'package:custom_note/containers/childrens/book_child_container.dart';

class BookContainer extends StatefulWidget {
  final Solo solo;
  final double listViewWidth;
  const BookContainer(
      {Key? key, required this.solo, required this.listViewWidth})
      : super(key: key);

  @override
  _BookContainerState createState() => _BookContainerState();
}

class _BookContainerState extends State<BookContainer> {
  IconData containerIcon = Icons.book_outlined;
  bool fold = false;
  bool setting = false;
  late Solo book;
  late Size containerSize;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = widget.solo;
    containerSize = Size(widget.listViewWidth, 80);
  }

  @override
  Widget build(BuildContext context) {
    bool checkBoxShow = context.watch<SoloProvider>().getCheckBoxShow;
    bool isChecked = context.watch<SoloProvider>().getsoloCheck(book);

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    //styles
    ContainerStyles containerStyles =
        ContainerStyles(colorScheme: colorScheme, context: context, solo: book);

    Size childAddAreaSize = Size(containerSize.width, 30);

    return GestureDetector(
      //터치
      onTap: () {
        setState(() {
          fold = !fold;
        });
      },
      //꾹누르기
      onLongPress: () {
        context.read<SoloProvider>().updateCheckBoxShow(true);
        context.read<SoloProvider>().updateSoloCheck(solo: book, check: true);
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        width: containerSize.width,
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
        child: Column(
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    //체크박스
                    if (checkBoxShow)
                      containerStyles.getContainerCheckBox(
                          isChecked: isChecked, setState: setState),

                    containerStyles.getContainerIcon(
                        iconData: Icons.book_outlined),

                    // 책 이름
                    Expanded(child: Text(book.value)),

                    //setting
                    fold
                        ? IconButton(
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
                fold
                    ? const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Icon(Icons.arrow_drop_up))
                    : const SizedBox()
              ],
            ),
            fold
                ? BookChildContainer(
                    book: book, containerSize: containerSize, setting: setting)
                : const SizedBox(),
            GestureDetector(
              onTap: () {
                if (fold) {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          CreateBookChildDialog(motherId: book.id));
                } else {
                  setState(() {
                    fold = !fold;
                  });
                }
              },
              child: Container(
                width: childAddAreaSize.width,
                height: childAddAreaSize.height,
                decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          ContainerStyles.containerRadius,
                        ),
                        bottomRight:
                            Radius.circular(ContainerStyles.containerRadius))),
                child: Center(
                  child: fold
                      ? Icon(
                          Icons.bookmark_add_outlined,
                          color: colorScheme.primary,
                        )
                      : const Icon(Icons.arrow_drop_down_rounded),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
