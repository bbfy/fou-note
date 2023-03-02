import 'package:flutter/material.dart';
//element
import 'package:custom_note/elements/child.dart';

//draw widget

import 'package:custom_note/containers/etc/draw_widget.dart';

import 'package:provider/provider.dart';
import 'package:custom_note/providers/db_sqlite_provider.dart';

class NoteChildScreen extends StatefulWidget {
  final Child child;
  const NoteChildScreen({Key? key, required this.child}) : super(key: key);

  @override
  _NoteChildScreenState createState() => _NoteChildScreenState();
}

class _NoteChildScreenState extends State<NoteChildScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isAdded = true;

  @override
  void dispose() {
    _scaffoldKey.currentContext
        ?.read<DbSqliteProvider>()
        .updateChild(widget.child);
    super.dispose();
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //element
    Child noteChild = widget.child;
    //color
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    //size
    Size containerSize = MediaQuery.of(context).size;
    //field size
    Size fieldSize =
        Size(containerSize.width * 0.85, containerSize.height * 0.85);

    Size buttonFieldSize = Size(fieldSize.width * 0.7, fieldSize.height * 0.1);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: colorScheme.tertiaryContainer,
        body: Center(
          child: SizedBox(
            width: fieldSize.width,
            height: fieldSize.height,
            child: Stack(children: [
              Center(
                child: DrawWidget(
                  noteChild: noteChild,
                  fieldSize: fieldSize,
                  controller: textEditingController,
                  onChange: () {},
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: buttonFieldSize.width,
                  height: buttonFieldSize.height,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: colorScheme.tertiaryContainer)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.rotate_left_sharp,
                          color: colorScheme.tertiary,
                        )),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
