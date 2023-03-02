import 'package:flutter/material.dart';

//show
import 'package:custom_note/screens/tabs/child_screen.dart';
//element
import 'package:custom_note/elements/solo.dart';

// provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/soloProvider.dart';

import 'package:custom_note/styles/containerStyles.dart';

class NoteContainer extends StatefulWidget {
  final Solo solo;
  final double listViewWidth;

  const NoteContainer(
      {Key? key, required this.solo, required this.listViewWidth})
      : super(key: key);

  @override
  _NoteContainerState createState() => _NoteContainerState();
}

class _NoteContainerState extends State<NoteContainer> {
  @override
  Widget build(BuildContext context) {
    Solo solo = widget.solo;
    //size
    Size containerSize = Size(widget.listViewWidth * 0.85, 50);
    double containerWidth = containerSize.width;
    // setstate for android screen
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    //styles
    ContainerStyles containerStyles =
        ContainerStyles(colorScheme: colorScheme, context: context, solo: solo);

    bool checkBoxShow = context.watch<SoloProvider>().getCheckBoxShow;
    bool isChecked = context.watch<SoloProvider>().getsoloCheck(solo);
    return GestureDetector(
      onPanUpdate: (details) {
        //오른쪽
        if (details.delta.dx > 0) {
          setState(() {
            containerWidth -= details.delta.dx;
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
            return ChildScreen(
              mother: solo,
            );
          }),
        );
      },
      //꾹누르기
      onLongPress: () {
        context.read<SoloProvider>().updateCheckBoxShow(true);
        context.read<SoloProvider>().updateSoloCheck(solo: solo, check: true);
      },
      child: Container(
        decoration: containerStyles.getContainerDecoration(),
        width: containerWidth,
        height: containerSize.height,
        child: Row(
          children: [
            //체크박스
            if (checkBoxShow)
              containerStyles.getContainerCheckBox(
                  isChecked: isChecked, setState: setState),

            //폴더 아이콘
            containerStyles.getContainerIcon(iconData: Icons.folder_open),

            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                solo.value,
                style: const TextStyle(color: Colors.black87),
              ),
            )),
            // 이름 표시 text

            //수정 버튼
            containerStyles.getContainerEditButton(),
          ],
        ),
      ),
    );
  }
}
