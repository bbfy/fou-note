import 'package:flutter/material.dart';

class TabStyles {
  BuildContext context;
  ColorScheme colorScheme;
  Size etcOneSize = const Size(70, 40);
  TabStyles({required this.context, required this.colorScheme});

  Widget getCenterIcon(IconData iconData) {
    return Icon(
      iconData,
      size: 100,
      color: colorScheme.secondaryContainer,
    );
  }

  Widget getFloatingButton({required void Function() addButtonOnPressed}) {
    return FloatingActionButton(
        backgroundColor: colorScheme.tertiaryContainer,
        onPressed: addButtonOnPressed,
        child: Icon(
          Icons.add,
          color: colorScheme.tertiary,
        ));
  }

  Widget getEtcPopupMenuButton(
      {required bool enable,
      required void Function() chekBoxShowOnTap,
      required void Function() toggleAllOnTap,
      required void Function() deleteOnTap}) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.over,
      offset: const Offset(30, -170),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.tertiaryContainer),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(Icons.more_horiz),
      ),
      itemBuilder: (context) => [
        PopupItem(
            child: StatefulBuilder(
                builder: (context, menuSetState) => Column(
                      children: [
                        getEtc(
                            iconData: Icons.check_box_outline_blank,
                            size: etcOneSize,
                            onTap: () {
                              chekBoxShowOnTap();
                              menuSetState(
                                () {
                                  enable = !enable;
                                },
                              );
                            },
                            enable: true),
                        getEtc(
                            iconData: Icons.check_box_outlined,
                            size: etcOneSize,
                            onTap: toggleAllOnTap,
                            enable: enable),
                        getEtc(
                            iconData: Icons.delete,
                            color: colorScheme.error,
                            onTap: deleteOnTap,
                            size: etcOneSize,
                            enable: enable)
                      ],
                    ))),
      ],
    );
  }

  Column getMenuItemColumn(
      {required bool enable,
      required void Function() chekBoxShowOnTap,
      required void Function() toggleAllOnTap,
      required void Function() deleteOnTap}) {
    return Column(
      children: [
        getEtc(
            iconData: Icons.check_box_outline_blank,
            size: etcOneSize,
            onTap: chekBoxShowOnTap,
            enable: true),
        getEtc(
            iconData: Icons.check_box_outlined,
            size: etcOneSize,
            onTap: toggleAllOnTap,
            enable: enable),
        getEtc(
            iconData: Icons.delete,
            color: colorScheme.error,
            onTap: deleteOnTap,
            size: etcOneSize,
            enable: enable)
      ],
    );
  }

  Widget getEtc(
      {required IconData iconData,
      Color? color,
      required Size size,
      required void Function() onTap,
      required bool enable}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: enable ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(
            child: Icon(
              iconData,
              color: enable
                  ? color
                  : Theme.of(context).colorScheme.outline.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}

class PopupItem extends PopupMenuItem {
  const PopupItem({
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  _PopupItemState createState() => _PopupItemState();
}

class _PopupItemState extends PopupMenuItemState {
  @override
  void handleTap() {
    widget.onTap?.call();
  }
}
