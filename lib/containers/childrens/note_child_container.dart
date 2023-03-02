import 'package:flutter/material.dart';

//dialog
//provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/childProvider.dart';

//elements
import 'package:custom_note/elements/child.dart';
import 'package:custom_note/screens/tabs/note_child_screen.dart';

class NoteChildContainer extends StatefulWidget {
  final Child child;
  final double listViewWidth;
  const NoteChildContainer(
      {Key? key, required this.child, required this.listViewWidth})
      : super(key: key);
  @override
  _NoteChildContainerState createState() => _NoteChildContainerState();
}

class _NoteChildContainerState extends State<NoteChildContainer> {
  @override
  Widget build(BuildContext context) {
    final Child child = widget.child;

    //size
    Size containerSize = Size(widget.listViewWidth, 50);

    double containerWidth = containerSize.width;

    double iconWidth = containerWidth * 0.06;

    //color
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    //check
    bool checkBoxShow = context.watch<ChildProvider>().getCheckBoxShow;
    bool isChecked = context.watch<ChildProvider>().getChildCheck(child);

    return GestureDetector(
      onPanUpdate: (details) {
        //오른쪽
        if (details.delta.dx > 0) {
          setState(() {
            containerWidth -= details.delta.dx;
            // details.delta.dx;
          });
        }
        // 왼쪽
        else if (details.delta.dx < 0) {}
      },
      //터치
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return NoteChildScreen(
              child: child,
            );
          }),
        );
      },
      //꾹누르기
      onLongPress: () {
        context.read<ChildProvider>().updateCheckBoxShow(true);
        context
            .read<ChildProvider>()
            .updateChildCheck(child: child, check: true);
      },
      child: Container(
        width: containerWidth,
        height: containerSize.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.tertiaryContainer
                ]),
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.onPrimaryContainer.withOpacity(0.5)),
        child: Row(
          children: [
            //체크박스
            checkBoxShow
                ? Checkbox(
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = !isChecked;
                        context
                            .read<ChildProvider>()
                            .updateChildCheck(child: child, check: isChecked);
                      });
                    },
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
              child: SizedBox(
                width: iconWidth,
                child: Stack(children: [
                  child.subValue.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(
                            Icons.brush,
                            color: colorScheme.primary,
                            size: 13,
                          ),
                        ),

                  // 아이콘
                  Center(
                    child: Icon(
                      Icons.description_outlined,
                      color: colorScheme.primary,
                    ),
                  ),
                ]),
              ),
            ),

            /// 아이콘

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  child.value,
                  // textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  //maxLines를 늘리면 늘어남
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
