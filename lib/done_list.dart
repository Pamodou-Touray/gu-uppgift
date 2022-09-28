import "package:flutter/material.dart";
import 'package:ny_skol_uppgift/modell.dart';

class DoneList extends StatefulWidget {
  final List<Modellen> doneLista;
  // final Function delete;
  // final Function done;

  DoneList(this.doneLista);
  @override
  State<DoneList> createState() => _DoneListState();
}

class _DoneListState extends State<DoneList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Done tasks"),
        ),
        body: widget.doneLista.isEmpty
            ? Center(
                child: Text(
                  "Tom",
                  style: TextStyle(fontSize: 40),
                ),
              )
            : ListView.builder(
                itemCount: widget.doneLista.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    height: 100,
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Text(widget.doneLista[index].titel as String,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            widget.doneLista[index].kommentar as String,
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
