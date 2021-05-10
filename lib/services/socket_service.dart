

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  OnLine,
  Offline,
  Connecting
}

//Se usa el change notifier para notificar sobre la respuesta de la API para refrescar el UI con cualquier cambio o cualquier que este trabajando con el socket
class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
   IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService() {
    this._initConfig();
  }


  void _initConfig(){

    // Dart client
    this._socket = IO.io('http://192.168.0.8:3000', {
      'transports' : ['websocket'],
      'autoConnect': true,
    });
    
    this._socket.onConnect((_) {
      // print('connect');
      this._serverStatus = ServerStatus.OnLine;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }

}