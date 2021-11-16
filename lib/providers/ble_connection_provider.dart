import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';

class BleConnection with ChangeNotifier {
  //region bluetooth connection
  final String SERVICE_UUDI = "d973f2e0-b19e-11e2-9e96-0800200c9a66";
  final String CHARACTERISTIC_READ_UUDI =
      "d973f2e1-b19e-11e2-9e96-0800200c9a66"; //read
  final String CHARACTERISTIC_WRITE_UUDI =
      "d973f2e2-b19e-11e2-9e96-0800200c9a66"; //write
  BluetoothCharacteristic readCharacteristic, writeCharacteristic;
  BluetoothDevice bleDevice;
  bool isReady = false;
  bool isThereValue = false;

  final String errorConnectionText = "Connection failed";
  StreamSubscription<List<int>> sub;
  String _readValue = "0.00";
  List<String> _iMUValues = ["0.00", "0.00", "0.00"];
  //endregion

  connectToDevice(BluetoothDevice device) async {
    if (device == null) {
      //_pop();
      return;
    }
/*    new Timer(const Duration(seconds: 40), () {
      if (!isReady) {
        disconnectFromDevice();
        showToast(errorConnectionText);
        //_pop();
      }
    });*/

    await device.connect().timeout(Duration(seconds: 40), onTimeout: () {
      disconnectFromDevice();
      showToast(errorConnectionText);
      return;
    }); //do not forget the timer and auto connect in connect fun
    bleDevice = device;
    print("discoverServices");
    discoverServices();
  }

  disconnectFromDevice() {
    if (bleDevice == null) {
      //_pop();
      return;
    }
    bleDevice.disconnect();
  }

  discoverServices() async {
    if (bleDevice == null) {
      //_pop();
      return;
    }
    List<BluetoothService> services = await bleDevice.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUDI) {
        service
          ..characteristics.forEach((characteristic) {
            if (characteristic.uuid.toString() == CHARACTERISTIC_READ_UUDI) {
              characteristic.setNotifyValue(true);
              isReady = true;
              ////
              if (CHARACTERISTIC_READ_UUDI == characteristic.uuid.toString()) {
                readCharacteristic = characteristic;
                print("read");
                receiveMessage();
                notifyListeners();
              }
              if (CHARACTERISTIC_WRITE_UUDI == characteristic.uuid.toString()) {
                writeCharacteristic = characteristic;
                print("write");
              }
            }
          });
      }
    });
    if (!isReady) {
      //_pop();
      showToast(errorConnectionText);
    }
  }

  receiveMessage() async {
    sub = readCharacteristic.value.listen((value) {
      print(value);
      _readValue = _dataParser(value);
      if (value.length == 12) {
        _iMUValues[0] = _dataParser(value.sublist(0, 4));
        _iMUValues[1] = _dataParser(value.sublist(4, 8));
        _iMUValues[2] = _dataParser(value.sublist(8));
      }
      isThereValue = true;
      print(_dataParser(value));
      notifyListeners();
    });
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  writeData(List<int> data) async {
    if (bleDevice == null || writeCharacteristic == null || !isReady) {
      showToast(errorConnectionText);
      sub.cancel();
      //_pop();
      return;
    }
    try {
      await writeCharacteristic.write(data);
    } catch (e) {
      showToast(errorConnectionText);
    }
  }

  String get getReadValue {
    isThereValue = false;
    return _readValue;
  }

  List<String> get getIMUValue {
    isThereValue = false;
    return _iMUValues;
  }
}
