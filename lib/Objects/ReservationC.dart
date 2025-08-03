class Reservations {
  String id;
  int spot; // patient spot 'la place de patient'
  int spots; // all spots available
  int emptyspots;
  int indexspot;
  String date;

  Reservations({
    required this.id,
    required this.spot,
    required this.spots,
    required this.emptyspots,
    required this.indexspot,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'spot' : spot,
      'spots' : spots,
      'emptyspots' : emptyspots,
      'indexspot' : indexspot,
      'date' : date,
    };
  }
}