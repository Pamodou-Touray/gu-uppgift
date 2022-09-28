import '/modell.dart';
import "package:flutter/material.dart";

class TodoList extends StatelessWidget {
  final List<Modellen> listan;
  final Function delete;
  final Function done;
  final Function isTodoDone;
  final List<Modellen> doneLista;
  final List<Modellen> undoneLista;

  TodoList(this.listan, this.delete, this.done, this.isTodoDone, this.doneLista,
      this.undoneLista);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listan.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: <Widget>[
              Text(listan[index].titel as String,
                  style: isTodoDone(listan[index].id)
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)
                      : TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                listan[index].kommentar as String,
                style: isTodoDone(listan[index].id)
                    ? TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 17,
                      )
                    : TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {
                          done(listan[index].id);
                        },
                        icon: isTodoDone(listan[index].id)
                            ? Icon(Icons.check_box)
                            : Icon(
                                Icons.check_box_outline_blank) //if checka här
                        ),
                    IconButton(
                      onPressed: () => delete(listan[index].id),
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
              Text("${listan[index].favorite}")
            ],
          ),
        );
      },
    );
  }
}

// listan.any((element) => element.id == doneLista[index].id) ? Icon(Icons.favorite) :  Icon(Icons.favorite_border))

//listan.any((Lelement) => doneLista.any((dElement) => Lelement.id == dElement.id))