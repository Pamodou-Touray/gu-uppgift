import "package:flutter/material.dart";
import 'package:ny_skol_uppgift/done_list.dart';
import 'package:ny_skol_uppgift/modell.dart';
import 'package:ny_skol_uppgift/undone_list.dart';

class DrawerList extends StatefulWidget {
  final List<Modellen> done;
  final List<Modellen> undone;

  DrawerList(this.done, this.undone);

  @override
  State<DrawerList> createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 120),
        ),
        GestureDetector(
          child: Row(
            children: [
              Icon(Icons.done),
              Text(
                "Done",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => DoneList(widget.done),
              ),
            );
          },
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 60),
        ),
        GestureDetector(
          child: Row(
            children: [
              Icon(Icons.check_box_outline_blank),
              Text(
                "Undone",
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => UndoneList(widget.undone),
              ),
            );
          },
        ),
      ],
    );
  }
}
