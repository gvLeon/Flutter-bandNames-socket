class Band {
  
  String id;
  String name;
  dynamic votes;

//Constructor
  Band({
    this.id,
    this.name,
    this.votes
  });

//Regresa una nueva instancia de la clase mediante un map con un objeto
  factory Band.fromMap(Map<String, dynamic> obj) 
  => Band (
    id   : obj.containsKey('id') ? obj['id'] : 'no-id',
    name : obj.containsKey('name') ? obj['name'] : 'no-name',
    votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes',
  );

}