class Case {
  final String id;
  final String location;
  final String problemDescription;
  final String mainFlag;
  final String status;

  Case ({required this.id, required this.location,
   required this.problemDescription, required this.mainFlag, required this.status});

  factory Case.fromJson(Map<String, dynamic> json) { 
  //Funcion que crea un objeto para los casos a partir de el JSON que envia el backend.
    return Case(
      id: json['_id'],
      location: json['location'],
      problemDescription: json['problem_description'],
      mainFlag: json['main_flag'],
      status: json['status'],
    );
  }
}