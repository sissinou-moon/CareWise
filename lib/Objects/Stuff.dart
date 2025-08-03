class Stuff {
  String firstname;
  String lastname;
  String email;
  String id;
  String password;
  String sexe;
  String Did;
  bool state;

  Stuff({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.sexe,
    required this.Did,
    required this.state,
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'firstname' : firstname,
      'lastname' : lastname,
      'email' : email,
      'password' : password,
      'sexe' : sexe,
      'Did' : Did,
      'state' : state,
    };
  }
}