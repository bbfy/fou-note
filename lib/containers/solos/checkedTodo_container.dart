import 'package:custom_note/elements/solo.dart';
import 'package:flutter/material.dart';

//provider
import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';
import 'package:custom_note/providers/todo_provider.dart';

import 'package:custom_note/styles/containerStyles.dart';

//audio
import 'package:audioplayers/audioplayers.dart';

class CheckedTodoContainer extends StatefulWidget {
  final Solo todo;
  final double listViewWidth;
  const CheckedTodoContainer(
      {Key? key, required this.todo, required this.listViewWidth})
      : super(key: key);

  @override
  _CheckedTodoContainerState createState() => _CheckedTodoContainerState();
}

class _CheckedTodoContainerState extends State<CheckedTodoContainer> {
  void todoChecked(Solo todo) {
    playButtonEffect();
    context.read<TodoProvider>().delTodoList(todo);
    context.read<DbSqliteProvider>().addSolo(todo);
  }

  void playButtonEffect() async {
    AudioCache audioCache = AudioCache();
    audioCache.play('audio/Blop-Mark_DiAngelo.wav');
  }

  @override
  Widget build(BuildContext context) {
    Solo todo = widget.todo;

    Size containerSize = Size(widget.listViewWidth * 0.8, 40);

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    ContainerStyles containerStyles =
        ContainerStyles(colorScheme: colorScheme, context: context, solo: todo);
    return GestureDetector(
      //누르면 복구
      onTap: () {
        // todoChecked(todo);
      },
      child: Container(
        constraints: BoxConstraints(minHeight: containerSize.height),
        width: containerSize.width,
        height: containerSize.height,
        decoration: containerStyles.getContainerDecoration(),
        child: Row(
          children: [
            //체크박스
            // if (checkBoxShow)
            //   containerStyles.getContainerCheckBox(
            //       isChecked: isChecked, setState: setState),

            //todo button
            TodoButton(
              todo: widget.todo,
              colorScheme: colorScheme,
              checkFunc: todoChecked,
            ),
            //todo text
            Expanded(
                child: Text(
              style: TextStyle(
                  color: Colors.blueGrey.shade400,
                  decoration: TextDecoration.lineThrough),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              todo.value,
            )),

            //수정 버튼
            // containerStyles.getContainerEditButton(),
          ],
        ),
      ),
    );
  }
}

class TodoButton extends StatefulWidget {
  final Solo todo;
  final ColorScheme colorScheme;
  final Function checkFunc;
  const TodoButton(
      {Key? key,
      required this.todo,
      required this.colorScheme,
      required this.checkFunc})
      : super(key: key);

  @override
  _TodoButtonState createState() => _TodoButtonState();
}

class _TodoButtonState extends State<TodoButton> {
  bool checked = true;

  @override
  Widget build(BuildContext context) {
    Solo todo = widget.todo;
    ColorScheme colorScheme = widget.colorScheme;
    Function checkFunc = widget.checkFunc;
    return IconButton(
      color: colorScheme.secondary.withOpacity(0.6),
      padding: EdgeInsets.zero,
      icon: checked
          ? const Icon(Icons.check_circle_outlined)
          : const Icon(Icons.circle_outlined),
      onPressed: () {
        setState(() {
          checked = !checked;
          checkFunc(todo);
        });
      },
    );
  }
}
