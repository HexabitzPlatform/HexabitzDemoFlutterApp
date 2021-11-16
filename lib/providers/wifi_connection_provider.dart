import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';

class WIFIConnection with ChangeNotifier {
  String _ipWifi = "192.168.4.1";
  String _portWifi = "3333";
  bool _isReady = false;
  bool _isThereValue = false;
  String _readValue = "0.00";
  List<String> _iMUValues = ["0.00", "0.00", "0.00"];
  Socket _socket;
  List<int> _values = [];
  final String errorConnectionText = "Connection failed";

  void connectToDevice() {
    print("ip:$_ipWifi");
    print("port:$_portWifi");
    int portIListenOn = int.parse(_portWifi); //0 is random
    Socket.connect("$_ipWifi", portIListenOn).then((sock) {
      _socket = sock;
      _isReady = true;
      _socket.listen(
        receiveMessage,
        onError: errorHandler,
        onDone: doneHandler,
        cancelOnError: false,
      );
    }).catchError((e) {
      print("Unable to connect: $e");
      showToast(errorConnectionText);
    });
  }

  void receiveMessage(data) {
    if (data.length == 1) {
      _values.addAll(data);
    } else {
      _values.addAll(data);
      print(_values);
      _readValue = _dataParser(_values);
      if (_values.length == 12) {
        _iMUValues[0] = _dataParser(_values.sublist(0, 4));
        _iMUValues[1] = _dataParser(_values.sublist(4, 8));
        _iMUValues[2] = _dataParser(_values.sublist(8));
      }
      _isThereValue = true;
      print(_dataParser(_values));
      _values = [];
      _isThereValue = true;
      notifyListeners();
    }
  }

  Future<void> writeData(List<int> data) async {
    if (_isReady && _socket != null) {
      _socket.write(data);
    } else {
      showToast(errorConnectionText);
    }
  }

  void disconnectFromDevice() {
    if (_socket != null) {
      _socket.close();
      _isReady = false;
    }
  }

  void errorHandler(error, StackTrace trace) {
    showToast(errorConnectionText);
    print(error);
  }

  void doneHandler() {
    _socket.destroy();
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  String get getReadValue {
    _isThereValue = false;
    return _readValue;
  }

  List<String> get getIMUValue {
    _isThereValue = false;
    return _iMUValues;
  }

  @override
  void dispose() {
    disconnectFromDevice();
    super.dispose();
  }
}
