import "package:flutter/material.dart";
import 'package:ny_skol_uppgift/drawer_list.dart';
import "modell.dart";
import "ny_todo.dart";
import "todo_listan.dart";
import "package:http/http.dart" as http;
import "dart:convert";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      title: "It Högskolan Flutter App",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLoading = false;
  List<Modellen> helaTodoListan = [];
  final List<Modellen> doneList = [];
  List<Modellen> undoneList = [];

  void startTodo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => GestureDetector(
        child: NyTodo(adderaNyTodo, 32),
      ),
    );
  }

  void adderaNyTodo(Modellen modellen) async {
    var response = await http
        .post(
      Uri.parse(
          "https://nytt-objekt-flutter-default-rtdb.firebaseio.com/todoTask.json"),
      body: jsonEncode(
        {
          "todo": modellen.titel,
          "kommentar": modellen.kommentar,
          "bool": modellen.favorite
        },
      ),
    )
        .then((response) {
      var jsonData = response.body;
      var obj = json.decode(response.body);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;

      final newToDo = Modellen(
          titel: modellen.titel,
          kommentar: modellen.kommentar,
          id: json.decode(response.body)["name"] as String,
          favorite: modellen.favorite);

      setState(() {
        helaTodoListan.add(newToDo);
        undoneList.add(newToDo);
      });
    });
  }

  void delete(String id) {
    setState(() {
      final url = Uri.parse(
          "https://nytt-objekt-flutter-default-rtdb.firebaseio.com/todoTask/$id.json");
      http.delete(url);
      helaTodoListan.removeWhere((element) => element.id == id);
      undoneList.removeWhere((element) => element.id == id);

      doneList.removeWhere((element) => element.id == id);
    });
  }

  void done(String id) {
    setState(() {
      if (doneList.any((element) => element.id == id)) {
        undoneList.add(
          helaTodoListan.firstWhere((element) => element.id == id),
        );
        doneList.removeWhere((element) => element.id == id);
        final existingIndex =
            helaTodoListan.indexWhere((element) => element.id == id);
        helaTodoListan[existingIndex].favorite = false;
        final url = Uri.parse(
            "https://nytt-objekt-flutter-default-rtdb.firebaseio.com/todoTask/$id.json");
        http.put(url,
            body: jsonEncode({
              "todo": helaTodoListan[existingIndex].titel,
              "kommentar": helaTodoListan[existingIndex].kommentar,
              "id": id,
              "favorite": false
            }));
      } else {
        doneList.add(
          helaTodoListan.firstWhere((todo) => todo.id == id),
        );
        undoneList.removeWhere((element) => element.id == id);
        final existingIndex =
            helaTodoListan.indexWhere((element) => element.id == id);
        helaTodoListan[existingIndex].favorite = true;
        final url = Uri.parse(
            "https://nytt-objekt-flutter-default-rtdb.firebaseio.com/todoTask/$id.json");
        http.put(url,
            body: jsonEncode({
              "todo": helaTodoListan[existingIndex].titel,
              "kommentar": helaTodoListan[existingIndex].kommentar,
              "id": id,
              "favorite": true
            }));
      }
    });
  }

  bool isTodoDone(String id) {
    return doneList.any((todo) => todo.id == id);
  }

  void _doStuff() async {
    var result = await fetchInternetStuff();
  }

  Future<Object?> fetchInternetStuff() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await http.get(
      Uri.parse(
          "https://nytt-objekt-flutter-default-rtdb.firebaseio.com/todoTask.json"),
    );

    var jsonData = response.body;
    var obj = jsonDecode(jsonData);
    if (obj == null) {
      setState(() {
        isLoading = false;
      });
    } else {
      var tom = [];
      setState(() {
        obj.forEach((prodId, prodData) {
          tom.add(
            Modellen(
                id: prodId,
                titel: prodData["todo"],
                kommentar: prodData["kommentar"],
                favorite: prodData["favorite"]),
          );
        });

        tom.forEach(
          (element) {
            var element_modellen = element as Modellen;
            if (helaTodoListan.any((el) => el.id == element_modellen.id)) {
              return null;
            } else {
              helaTodoListan.add(element_modellen);
            }
          },
        );
        tom.forEach(
          (element) {
            var element_modellen = element as Modellen;
            // print(element_modellen.favorite); Nya orörda todos bools kommer in som null här?
            //Försvinner när man done och undone de, men om de är orörda är de null
            //Men inte null i databasen?
            if (element_modellen.favorite == null) {
              if (undoneList.any((el) => el.id == element_modellen.id)) {
                return null;
              } else {
                setState(() {
                  element_modellen.favorite = false;
                });
                undoneList.add(element_modellen);
              }
            } else if (element_modellen.favorite == false) {
              if (undoneList.any((el) => el.id == element_modellen.id)) {
                return null;
              } else {
                undoneList.add(element_modellen);
              }
            } else if (element_modellen.favorite == true) {
              if (doneList.any((el) => el.id == element_modellen.id)) {
                return null;
              } else {
                doneList.add(element_modellen);
              }
            }
          },
        );
      });

      setState(() {
        isLoading = false;
      });

      return tom;
    }
  }

  @override
  void initState() {
    _doStuff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: DrawerList(doneList, undoneList)),
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 0),
              ),
              Text("To do app"),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: _doStuff,
              )
            ]),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : helaTodoListan.isEmpty
              ? Center(
                  child: Text(
                    "Tom",
                    style: TextStyle(fontSize: 40),
                  ),
                )
              : TodoList(helaTodoListan, delete, done, isTodoDone, doneList,
                  undoneList),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startTodo(context),
      ),
    );
  }
}
