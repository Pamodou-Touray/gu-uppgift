import "package:flutter/material.dart";
import 'package:ny_skol_uppgift/modell.dart';

class UndoneList extends StatefulWidget {
  final List<Modellen> undoneLista;

  UndoneList(this.undoneLista);
  @override
  State<UndoneList> createState() => _UndoneListState();
}

class _UndoneListState extends State<UndoneList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Undone tasks"),
        ),
        body: widget.undoneLista.isEmpty
            ? Center(
                child: Text(
                  "Tom",
                  style: TextStyle(fontSize: 40),
                ),
              )
            : ListView.builder(
                itemCount: widget.undoneLista.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: 100,
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Text(widget.undoneLista[index].titel as String,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            widget.undoneLista[index].kommentar as String,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
