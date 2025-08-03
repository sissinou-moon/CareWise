class Doctor {
  String firstname;
  String lastname;
  String sexe;
  String email;
  String id;
  String speciality;
  int phonenumber;
  Map<String, dynamic> adr;
  bool yourown; // if this office is his own 
  String bio;
  String workDays;
  String workHours;
  double appointmentprice;
  Map relation; // hospital + staff

  Doctor(
    {
      required this.firstname,
      required this.lastname,
      required this.sexe,
      required this.email,
      required this.id,
      required this.speciality,
      required this.phonenumber,
      required this.adr,
      required this.yourown,
      required this.bio,
      required this.workDays,
      required this.workHours,
      required this.appointmentprice,
      required this.relation,
    }
  );

  Map<String, dynamic> toJson() {
    return {
      'firstname' : firstname,
      'lastname' : lastname,
      'sexe' : sexe,
      'email' : email,
      'id' : id,
      'speciality' : speciality,
      'phonenumber' : phonenumber,
      'adr' : adr,
      'yourown' : yourown,
      'bio' : bio,
      'workDays' : workDays,
      'workHours' : workHours,
      'relation' : relation,
    };
  }
}