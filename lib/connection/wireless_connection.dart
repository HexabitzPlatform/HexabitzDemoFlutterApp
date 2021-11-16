import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue/flutter_blue.dart';

class WirelessConnection {
  bool isBluetooth = true; // false if wifi
  BluetoothDevice device; // for bluetooth
  StreamController weightStream;

  //region bluetooth
  List<BluetoothService> services;
  BluetoothCharacteristic readCharacteristic, writeCharacteristic;
  //endregion
  WirelessConnection(
      {isBluetooth,
      BluetoothDevice bluetoothDevice,
      StreamController streamController}) {
    print(isBluetooth);
    this.isBluetooth = isBluetooth;
    device = bluetoothDevice;
    this.weightStream = streamController;
    if (isBluetooth) {
      connection();
    }
  }
  Future<void> connection() async {
    if (isBluetooth) {
      //bluetooth
      {
        services = await device.discoverServices();
        print("X");
        // print(services);

        for (BluetoothService service in services) {
          for (BluetoothCharacteristic characteristic
              in service.characteristics) {
            print(characteristic.uuid.toString());
            if ("d973f2e1-b19e-11e2-9e96-0800200c9a66" ==
                characteristic.uuid.toString()) {
              readCharacteristic = characteristic;
              print("read");
            }
            if ("d973f2e2-b19e-11e2-9e96-0800200c9a66" ==
                characteristic.uuid.toString()) {
              writeCharacteristic = characteristic;
              print("write");
            }
          }
        }
        receiveMessage();
      }
    } else {
      //wifi
    }
  }

  sendMessage(Uint8List message) async {
    if (isBluetooth) {
      //Bluetooth
      await writeCharacteristic.write(message);
      print("write");
    } else {
      //WIFI
      print("write");
    }
  }

  receiveMessage() async {
    List<int> valueX = [];
    if (isBluetooth) {
      //Bluetooth
      await readCharacteristic.setNotifyValue(true);
/*      var descriptors = readCharacteristic.descriptors;
      print(descriptors.length);
      for (BluetoothDescriptor d in descriptors) {
        d.value.listen((event) {
          print(d.read());
        });
        // List<int> value = await d.read();
        //print(value);
      }*/

      var sub = readCharacteristic.value.listen((value) {
        valueX = value;
        print(value);
      });
      await readCharacteristic.read();
/*        List<int> value = await readCharacteristic.read();
      print(value); */
      sub.cancel();
    }
  }

  void test() {
    weightStream.sink.add("100");
  }
}
