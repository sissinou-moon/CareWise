class Hospital {
  String id;
  String name;
  Map<String, dynamic> adr; 
  /*
  adr = 
  {
    'wilaya' : 'relizane',
    'lat' : 38.64452315861,
    'long' : 0.54231874641,
  }
  */ 
  int doctorsnumber;
  int bedsnumber;
  Map<String, List> workers;
  /*
  workers = 
  {
    'doctors' :
    [
      {'id' : '12dsA9m#R' , 'speciality' : 'generaliste'},
    ]
    'nurses' :
    [
      's586F#R' , 's451T#R' ,
    ]
  }
  */

  Hospital(
    this.doctorsnumber,
    this.bedsnumber,
    this.workers,
    {
      required this.id,
      required this.name,
      required this.adr,
    }
  );

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name' : name,
      'adr' : adr,
      'doctorsnumber' : doctorsnumber,
      'bedsnumber' : bedsnumber,
      'workers' : workers,
    };
  }
}