class Modellen {
  String? titel;
  String? kommentar;
  String? id;
  bool? favorite;

  Modellen({this.titel, this.kommentar, this.id, this.favorite = false});

  Modellen.toJson(Map<String, dynamic> json) {
    titel = json["titel"];
    kommentar = json["kommentar"];
    id = json["id"];
  }
}
