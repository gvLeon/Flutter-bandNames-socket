class Band {
  
  String id;
  String name;
  String votes;

//Constructor
  Band({
    this.id,
    this.name,
    this.votes
  });

//Regresa una nueva instancia de la clase mediante un map con un objeto
  factory Band.fromMap(Map<String, dynamic> obj) 
  => Band (
    id: obj['id'],
    name: obj['name'],
    votes: obj['votes']
  );

}