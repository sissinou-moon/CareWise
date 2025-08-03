import 'package:carewise/Objects/Medicine.dart';

class Prescription {
  String code;
  String date;
  String Did;
  String Dfirstname;
  String Dlastname;
  String Pid;
  String Pfirstname;
  String Plastname;
  
  /*
    relation = 
    {
      'doctor' : '125OZC782NSK#U',
      'patient' : '664786FZPS',
    }
  */ 
  List<Map> medications;
  /*
   medications = ['DOLIPRANE' , 'EFFERALGAN']
  */

  Prescription({
    required this.code,
    required this.date,
    required this.Did,
    required this.Dfirstname,
    required this.Dlastname,
    required this.Pid,
    required this.Pfirstname,
    required this.Plastname,
    required this.medications,
  });

  Map<String, dynamic> toJson() {
    return {
      'code' : code,
      'date' : date,
      'Did' : Did,
      'Dfirstname' : Dfirstname,
      'Dlastname' : Dlastname,
      'Pid' : Pid,
      'Pfirstname' : Pfirstname,
      'Plastname' : Plastname,
      'medications' : medications,
    };
  }
}