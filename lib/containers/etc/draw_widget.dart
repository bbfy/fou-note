import 'package:flutter/material.dart';
//elements
import 'package:custom_note/elements/child.dart';
//color picker
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//math
import 'dart:math';

import 'dart:convert';

enum InputType { text, draw }

// text draw 값 보내줌 update, add 없음
class DrawWidget extends StatefulWidget {
  final Size fieldSize;
  final Child noteChild;
  final Function? inputFunc;
  final TextEditingController controller;
  final Function() onChange;

  const DrawWidget(
      {Key? key,
      required this.noteChild,
      required this.fieldSize,
      required this.controller,
      required this.onChange,
      this.inputFunc})
      : super(key: key);

  @override
  _DrawWidgetState createState() => _DrawWidgetState();
}

class _DrawWidgetState extends State<DrawWidget> {
  InputType inputType = InputType.text;

  late TextEditingController textEditingController;
  // draw
  Color color = Colors.black;
  double lineWeight = 1;
  List<List<DotInfo>> drawLines = <List<DotInfo>>[];
  //뒤로 가기 했을 때 남기는 용
  List<List<DotInfo>> trashLinesContainer = <List<DotInfo>>[];

  //textcontorller

  String savestr = '';
  @override
  void initState() {
    super.initState();
    initLines();
    setState(() {
      drawLineFromData();
    });
    textEditingController = widget.controller;
    textEditingController.text = widget.noteChild.value;
    textEditingController.selection =
        TextSelection.collapsed(offset: widget.noteChild.value.length);
  }

  void drawLineFromData() {
    if (widget.noteChild.subValue.isEmpty) return;
    //한 라인 분리
    widget.noteChild.subValue.split('+').forEach((element) {
      List<DotInfo> inner = [];
      //라인 속 dot list 분리
      element.split('-').forEach((element) {
        if (element.isEmpty) {
          drawLines.add(inner);
          return;
        }
        Map<String, dynamic> map = json.decode(element);
        List offsetList = map['offset']!.split('@');
        Offset offset =
            Offset(double.parse(offsetList[0]), double.parse(offsetList[1]));
        double lineWeight = map['lineWeight']! as double;
        Color color = Color(map['color']! as int);
        DotInfo dotInfo =
            DotInfo(offset: offset, color: color, lineWeight: lineWeight);

        inner.add(dotInfo);
      });
      drawLines.add(inner);
    });
  }

  void addDrawLineData(List<DotInfo> dotList) {
    if (widget.noteChild.subValue.isNotEmpty) {
      //리스트 구분은 +로
      widget.noteChild.subValue += '+';
    }
    for (var dotInfo in dotList) {
      widget.noteChild.subValue += dotInfo.toString();
      // dot 구분은 -로
      widget.noteChild.subValue += '-';
    }
  }

  void addDrawDotData(DotInfo dotInfo) {
    widget.noteChild.subValue += dotInfo.toString();
    widget.noteChild.subValue += '-';
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    //size
    Size fieldSize = widget.fieldSize;
    Size actionFieldSize = Size(fieldSize.width * 0.8, fieldSize.height * 0.1);
    Size textFieldSize = Size(fieldSize.width * 0.85, fieldSize.height * 0.8);

    return Container(
        width: fieldSize.width,
        height: fieldSize.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: colorScheme.background),
        child: Column(
          children: [
            SizedBox(
              width: actionFieldSize.width,
              height: actionFieldSize.height,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //텍스트 선택
                  IconButton(
                      isSelected: inputType == InputType.text,
                      selectedIcon:
                          Icon(Icons.text_fields, color: colorScheme.primary),
                      onPressed: () {
                        savestr = textEditingController.text;
                        widget.noteChild.value = savestr;
                        setState(() {
                          inputType = InputType.text;
                        });
                      },
                      icon: const Icon(Icons.text_fields)),
                  //그리기 선택
                  IconButton(
                      isSelected: inputType == InputType.draw,
                      selectedIcon: Icon(
                        Icons.draw,
                        color: colorScheme.primary,
                      ),
                      onPressed: () {
                        setState(() {
                          inputType = InputType.draw;
                        });
                      },
                      icon: const Icon(Icons.draw)),

                  //색
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: color,
                                onColorChanged: (value) {
                                  setState(() {
                                    color = value;
                                  });
                                },
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(Icons.check_circle_outline))
                            ],
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.palette,
                        color: color,
                      )),
                  //굵기

                  PopupMenuButton<double>(
                    position: PopupMenuPosition.under,
                    icon: const Icon(Icons.line_weight),
                    onSelected: (value) {
                      setState(() {
                        lineWeight = value;
                      });
                    },
                    itemBuilder: (context) => <PopupMenuEntry<double>>[
                      PopupMenuItem(
                        value: 1,
                        child: Container(
                          color: Colors.black,
                          height: 1,
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Container(
                          color: Colors.black,
                          height: 2,
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Container(
                          color: Colors.black,
                          height: 3,
                        ),
                      ),
                      PopupMenuItem(
                        value: 5,
                        child: Container(
                          color: Colors.black,
                          height: 5,
                        ),
                      ),
                      PopupMenuItem(
                        value: 8,
                        child: Container(
                          color: Colors.black,
                          height: 8,
                        ),
                      ),
                    ],
                  ),

                  //그린거 지우기
                  IconButton(
                      onPressed: () {
                        setState(() {
                          drawClear();
                        });
                      },
                      icon: const Icon(Icons.cleaning_services_sharp))
                ],
              ),
            ),

            // 텍스트 필드 및 그리기
            Container(
              width: textFieldSize.width,
              height: textFieldSize.height,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: colorScheme.outline.withOpacity(0.5), width: 0.5),
                  borderRadius: BorderRadius.circular(15)),
              //바깥은 못그리게 제한
              child: ClipRect(
                child: CustomPaint(
                  size: textFieldSize,
                  painter: PathPainter(lines: drawLines),
                  //누르는 거 감지
                  child: GestureDetector(
                    onPanStart: (details) {
                      inputType == InputType.draw
                          ? setState(() {
                              drawStart(
                                  details.localPosition, color, lineWeight);
                            })
                          : null;
                    },
                    onPanUpdate: (details) {
                      inputType == InputType.draw
                          ? setState(() {
                              drawing(details.localPosition, color, lineWeight);
                            })
                          : null;
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      //텍스트필드
                      child: TextField(
                        onSubmitted: (value) {
                          if (widget.inputFunc != null) {
                            widget.inputFunc!();
                          }
                        },
                        autofocus: true,
                        // readOnly: inputType != InputType.text,
                        decoration:
                            const InputDecoration.collapsed(hintText: ''),
                        minLines: 1,
                        maxLines: 10,
                        controller: textEditingController,
                        onChanged: (value) {
                          widget.onChange();
                          widget.noteChild.value = value;
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  // paint

  void addLine(List<DotInfo> line) {
    drawLines.add(line);
  }

  void drawClear() {
    drawLines.clear();
    widget.noteChild.subValue = '';
  }

  //그림판 기능 그리기 시작 lines에 위치 추가
  void drawStart(Offset offset, Color color, double lineWeight) {
    //개로운 선으로 리스트 추가
    List<DotInfo> oneLine = <DotInfo>[];
    oneLine.add(DotInfo(offset: offset, color: color, lineWeight: lineWeight));
    drawLines.add(oneLine);
    addDrawLineData(oneLine);
  }

  //그림판 기능 그리는 중lines에 위치 추가
  void drawing(Offset offset, Color color, double lineWeight) {
    //선을 잇기 위해 리스트에 계속 추가
    DotInfo dotInfo =
        DotInfo(offset: offset, color: color, lineWeight: lineWeight);
    drawLines.last.add(dotInfo);
    addDrawDotData(dotInfo);
  }

  //그림판 기능 지우기 lines에 위치 제거
  void erase(Offset offset, double lineWeight) {
    for (List<DotInfo> oneLine in List<List<DotInfo>>.from(drawLines)) {
      for (DotInfo oneDot in oneLine) {
        //마우스 위치와 점의 위치 사이의 거리가 size보다 작을 경우 없앰
        if (sqrt(pow(offset.dx - oneDot.offset.dx, 2) +
                pow(offset.dy - oneDot.offset.dy, 2)) <
            lineWeight) {
          drawLines.remove(oneLine);
          break;
        }
      }
    }
  }

  void initLines() {
    drawLines = <List<DotInfo>>[];
  }

  //되돌리기
  void revert() {
    if (drawLines.isEmpty) return;
    trashLinesContainer.add(drawLines.last);
    drawLines.removeLast();
  }

  //역되돌리기
  void unrevert() {
    if (trashLinesContainer.isEmpty) return;
    drawLines.add(trashLinesContainer.last);
    trashLinesContainer.removeLast();
  }
}

// draw

// 그려지는 패스용 클래스
class DotInfo {
  DotInfo(
      {required this.offset, required this.color, required this.lineWeight});
  final Offset offset;
  final double lineWeight;
  final Color color;

  @override
  String toString() {
    return '{"offset" : "${offset.dx}@${offset.dy}","lineWeight" : ${lineWeight.toString()},"color" : ${color.value.toString()}}';
  }

  DotInfo.fromMap(Map<String, Object?> map)
      : this(
            offset: map['offset']! as Offset,
            lineWeight: map['lineWeight']! as double,
            color: map['color']! as Color);
}

// 페인터는 path에 있는 것만 그림 그러니까 더 그리려면 path안의 리스트를 추가해야함
class PathPainter extends CustomPainter {
  final List<List<DotInfo>> lines;

  PathPainter({required this.lines});

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    //그리기 옵션
    // Paint paint = Paint()
    //   ..style = PaintingStyle.stroke
    //   ..strokeCap = StrokeCap.round;

    //그리기
    for (List<DotInfo> oneLine in lines) {
      Color color = Colors.black;
      double stokeSize = 8;
      Path path = Path();
      List<Offset> points = <Offset>[];
      for (DotInfo oneDot in oneLine) {
        points.add(oneDot.offset);
        color = oneDot.color;
        stokeSize = oneDot.lineWeight;
      }
      path.addPolygon(points, false);
      canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = stokeSize
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // throw UnimplementedError();
    return true;
  }
}
