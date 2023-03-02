import 'package:flutter/material.dart';

// provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';

//elements
import 'package:custom_note/elements/solo.dart';
import 'package:custom_note/elements/child.dart';
//style

//dialog
import 'package:custom_note/dialogs/child/update_book_child.dart';

//dataformat
import 'package:custom_note/elements/data_format.dart';

import 'package:date_format/date_format.dart';

class BookChildContainer extends StatefulWidget {
  final bool setting;
  final Solo book;
  final Size containerSize;
  const BookChildContainer({
    Key? key,
    required this.book,
    required this.containerSize,
    required this.setting,
  }) : super(key: key);

  @override
  _BookChildContainerState createState() => _BookChildContainerState();
}

class _BookChildContainerState extends State<BookChildContainer> {
  late Solo book;
  late Size containerSize;
  late Size ingredientSize;
  late Size processSize;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    book = widget.book;
    containerSize = widget.containerSize;
    ingredientSize = Size(containerSize.width, containerSize.height * 0.3);
    processSize = Size(containerSize.width, containerSize.height * 0.7);
  }

  @override
  Widget build(BuildContext context) {
    bool setting = widget.setting;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    List<Child> childList = context
        .watch<DbSqliteProvider>()
        .getChildList(ChildrenSort.bookChild, book.id);

    return SizedBox(
        width: containerSize.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.separated(
              padding: const EdgeInsets.only(top: 5),
              shrinkWrap: true,
              separatorBuilder: (context, index) => const Divider(
                thickness: 0.6,
                height: 5,
              ),
              itemCount: childList.length,
              itemBuilder: (context, index) => Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  //눌러서 수정
                  child: GestureDetector(
                    onTap: () {
                      setting
                          ? showDialog(
                              context: context,
                              builder: (context) => UpdateBookChildDialog(
                                    child: childList[index],
                                  ))
                          : () {};
                    },
                    child: Container(
                      decoration: setting
                          ? BoxDecoration(
                              color:
                                  colorScheme.primaryContainer.withOpacity(0.2),
                              // borderRadius: BorderRadius.circular(12)
                            )
                          : null,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            constraints: const BoxConstraints(minWidth: 20),
                            decoration: BoxDecoration(
                                color:
                                    colorScheme.inverseSurface.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text(
                                childList[index].value,
                                style: TextStyle(
                                    color: colorScheme.onInverseSurface),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            childList[index].subValue,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: colorScheme.inverseSurface,
                                fontSize: 12),
                          )),
                          Text(
                            formatDate(
                                childList[index].dt, [yyyy, '-', mm, '-', dd]),
                            style: TextStyle(
                                color: colorScheme.tertiary, fontSize: 10),
                          ),
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
                                        context
                                            .read<DbSqliteProvider>()
                                            .delChild(childList[index]);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 20,
                                        color:
                                            colorScheme.error.withOpacity(0.9),
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
