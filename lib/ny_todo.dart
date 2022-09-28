import "package:flutter/material.dart";
import "modell.dart";

class NyTodo extends StatefulWidget {
  final Function addTodo;
  final int nummer;

  NyTodo(this.addTodo, this.nummer);

  @override
  State<NyTodo> createState() => _NyTodoState();
}

class _NyTodoState extends State<NyTodo> {
  final todoController = TextEditingController();
  final commentController = TextEditingController();

  void skickaTillbaka() {
    final todo = todoController.text;
    final comment = commentController.text;
    var newToDo = Modellen(id: "", kommentar: comment, titel: todo);
    widget.addTodo(newToDo);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
            decoration: InputDecoration(labelText: "Titel"),
            controller: todoController),
        TextField(
          decoration: InputDecoration(labelText: "Kommentar"),
          controller: commentController,
        ),
        ElevatedButton(
          onPressed: skickaTillbaka,
          child: Text("Bekräfta"),
        )
      ],
    );
  }
}
