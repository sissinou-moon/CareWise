class Appointment {
  String id;
  bool fromapp;
  String date;
  String Did;
  String Dfirstname;
  String Dlastname;
  String Pfirstname;
  String Plastname;
  String Pid;
  int Pold;
  String state;
  int spot;
  bool paid;
  String paymentmethod;
  Map adr; // {locality : '', province : ''}

  Appointment({
    required this.id,
    required this.fromapp,
    required this.date,
    required this.Did,
    required this.Dfirstname,
    required this.Dlastname,
    required this.Pid,
    required this.Pfirstname,
    required this.Plastname,
    required this.Pold,
    required this.spot,
    required this.state,
    required this.paid,
    required this.paymentmethod,
    required this.adr,
  });

  Map<String, dynamic> toJson() {
    return {
      'Pfirstname' : Pfirstname,
      'fromapp' : fromapp,
      'Plastname' : Plastname,
      'Pold' : Pold,
      'Pid' : Pid,
      'date' : date,
      'state' : state,
      'spot' : spot,
      'Did' : Did,
      'Dfirstname' : Dfirstname,
      'Dlastname' : Dlastname,
      'id' : id,
      'paid' : paid,
      'paymentlethod' : paymentmethod,
      'adr' : adr,
    };
  }
}