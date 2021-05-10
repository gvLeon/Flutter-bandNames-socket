import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen:false);
    socketService.socket.on('active-bands', _handleActiveBands);

    super.initState();
  }

  _handleActiveBands(dynamic payload) {

    this.bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList();

        setState(() {});

  }

  //Dejar de escuchar el evento cuando se destruye la ventana
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen:false);
    socketService.socket.off('active-bands');
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title:Text('BandNames', style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.OnLine)
              ? Icon(Icons.check_circle, color: Colors.blue[300])
              : Icon(Icons.offline_bolt, color: Colors.red[300]),
          )
        ],
      ),

      body: Column(
        children: [
          _showGraph(),
          Expanded(
            flex: 500,
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => bandTile(bands[index])
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand),
    );
  }


  Widget bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen:false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,

      onDismissed: ( _ ) =>  socketService.socket.emit('delete-band', {'id':band.id} ),

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
        onTap: () => socketService.socket.emit('vote-band', { 'id':band.id } ),
      ),
    );
  }

  addNewBand() {

    final textController = new TextEditingController();

    //Si es android, muestra el show dialog de material, sino muestra el showDialog de cupertino
    if (!Platform.isAndroid){
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
          ),
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
    final socketService = Provider.of<SocketService>(context, listen:false);

    if (name.length >1) {
      socketService.socket.emit('add-band', {'name': name} );
    }


    Navigator.pop(context);
  }

  Widget _showGraph() {
    Map<String, double> dataMap = new Map();
    //dataMap.putIfAbsent('Flutter', () => 5);
    bands.forEach( (band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble() );
    });

    final List<Color> colorList =[
      Colors.blue[50],
      Colors.blue[200],
      Colors.pink[50],
      Colors.pink[200],
      Colors.yellow[50],
      Colors.yellow[200],
    ];

    return dataMap.isNotEmpty ? Container(
      child: PieChart(
      dataMap: dataMap,
      animationDuration: Duration(milliseconds: 800),
      chartLegendSpacing: 30,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      legendOptions: LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: ChartValuesOptions(
        showChartValueBackground: false,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    ),
      width: double.infinity,
      height: 200,
    ) : CircularProgressIndicator();
  }

}