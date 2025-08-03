class Nurse {
  String id;
  String firstname;
  String lastname;
  String sexe;
  String old;
  Map relation;
  /*
    relation = 
      {
        'id' : 8546TDS3189O#P,
        'type' : private,                                        "type = ['hospital', 'private']"
      }
  */

  Nurse(
    {
      required this.id,
      required this.firstname,
      required this.lastname,
      required this.sexe,
      required this.old,
      required this.relation,
    }
  );

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'firstname': firstname,
      'lastname' : lastname,
      'sexe' : sexe,
      'old' : old,
      'relation' : relation,
    };
  }
}