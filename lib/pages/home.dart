import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
  Band(id: '1',name: 'Metallica',votes: '5'),
  Band(id: '2',name: 'Queen',votes: '2'),
  Band(id: '3',name: 'Heroes del silencio',votes: '1'),
  Band(id: '4',name: 'Bon Jovi',votes: '3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title:Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white
      ),

      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, index) => bandTile(bands[index])

      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand),
    );
  }


  Widget bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,

      onDismissed: (direction) {
        print ('direction: $direction');
        //TODO: Llamar al borrado del server
      },

      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete band',style: TextStyle(color: Colors.white),),
        )
      ),

      child: ListTile(
        leading: CircleAvatar(
          child: Text( band.name.substring(0,2) ),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${ band.votes }',style: TextStyle(fontSize: 18),),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    //Si es android, muestra el show dialog de material, sino muestra el showDialog de cupertino
    if (!Platform.isAndroid){
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New band name: '),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text('Add'),
                elevation: 3,
                textColor: Colors.blue,
                onPressed: () => addBandToList(textController.text)
              )
            ],
          );
        },
      );
    }
    
    showCupertinoDialog(
      context: context,

      //El guion bajo se utiliza cuando no se va a utilizar una propiedad 
      builder: (_){
        return CupertinoAlertDialog(
          title: Text('New band name'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Add'),
              onPressed: () => addBandToList(textController.text)
            ),

            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text('Dismiss'),
              onPressed: ()=> Navigator.pop(context)
            ),
          ],
        );
      }
      );

  }

  void addBandToList(String name) {
    print(name);

    if (name.length >1) {
      //podemos agregar
      this.bands.add(new Band(id: DateTime.now().toString(), name: name, votes: '0') );

      setState(() {
        
      });
    }


    Navigator.pop(context);
  }

}