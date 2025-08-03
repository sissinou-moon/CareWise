class Patient {
  String id;
  String firstname;
  String lastname;
  int old;
  String sexe;
  String email;
  int phonenumber;
  String birthday;
  Map adr;
  bool allergic;
  String mentalstate;
  String socialstate;
  bool smoking;
  String physicalact;
  Map sheet;

  Patient(
   this.adr,
   this.mentalstate,
   this.physicalact,
   this.sheet,
   {
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.old,
    required this.sexe,
    required this.email,
    required this.phonenumber,
    required this.birthday,
    required this.allergic,
    required this.socialstate,
    required this.smoking,
   }
  );

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'firstname' : firstname,
      'lastname' : lastname,
      'old' : old,
      'sexe' : sexe,
      'email' : email,
      'phonenumber' : phonenumber,
      'birthday' : birthday,
      'adr' : adr,
      'allergic' : allergic,
      'mentalstate' : mentalstate,
      'socialstate' : socialstate,
      'smoking' : smoking,
      'physicalact' : physicalact,
      'sheet' : sheet,
    };
  }
}