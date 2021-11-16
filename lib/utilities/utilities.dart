import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hexabitz_demo_app/FLUTTER_WIRELESS_LIB/Message.dart';
import 'package:hexabitz_demo_app/providers/ble_connection_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

Future<bool> checkPermission(BuildContext ctx) async {
  //This for check Location permission
  //if IOS app did not work check this code (permission.locationWhenInUse.status)
  if (await Permission.location.request().isGranted) {
    return Future<bool>.value(true);
  } else {
    var status = await Permission.location.status;
    if (status.isDenied) print("Permission Denied");
    if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
      showDialog(
          context: ctx,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title: const Text('Location Permission'),
                content: const Text(
                    'This app needs Location access for bluetooth connection  '),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text(
                      'Deny',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                      child: const Text('Settings'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        openAppSettings();
                      }),
                ],
              ));
    }
    if (status.isGranted) {
      return Future<bool>.value(true);
    }
  }

  return Future<bool>.value(false);
  //print(status);
}

Future<bool> bluetoothLocationAreEnable(BuildContext ctx) async {
  bool locationIsEnable = await Permission.location.serviceStatus.isEnabled;
  bool bluetoothIsEnable = await FlutterBlue.instance.isOn;
  if (locationIsEnable && bluetoothIsEnable) {
    print("locationIsEnable");
    print("bluetoothIsEnable");
    //bluetoothConnection(ctx);
    return true;
  } else {
    if (!locationIsEnable && bluetoothIsEnable) {
      showToast("Enable Location to connect");
      print("not locationIsEnable");
    }
    if (!bluetoothIsEnable && locationIsEnable) {
      showToast("Enable Bluetooth to connect");
      print(" not bluetoothIsEnable");
    }
    if (!bluetoothIsEnable && !locationIsEnable) {
      showToast("Enable Bluetooth and Location to connect");
      print(" not bluetooth&LocationIsEnable");
    }
    return false;
  }
}

void showToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black38,
      textColor: Colors.white,
      fontSize: 16.0);
}

void sendMessage(BuildContext context, int destination, int source, int code,
    List<int> payload) {
  final bleConnection = Provider.of<BleConnection>(context, listen: false);
  String opt8NextMessage = "0";
  String opt67ResponseOptions = "01";
  String opt5Reserved = "0";
  String opt34TraceOptions = "00";
  String opt2_16BITCode = "0";
  String opt1ExtendedFlag = "0";

  if (code > 255)
    opt2_16BITCode = "1";
  else
    opt2_16BITCode = "0";
  String optionsString = opt8NextMessage +
      opt67ResponseOptions +
      opt5Reserved +
      opt34TraceOptions +
      opt2_16BITCode +
      opt1ExtendedFlag;

  int options = (int.parse(optionsString, radix: 2));
  Message message = Message(destination, source, options, code, payload);
  // print("scaleUnitCode:$scaleUnitCode");
  /////////////////////////////////////////
  //List<int> z = [];
  print("message:${message.getMessage()}");
  //connection.sendMessage(message.getMessage());
  //connection.test();

  if (!bleConnection.isReady)
    showToast("please connect with module to send data");
  else {
    checkPermission(context).then((value) => {
          if (value)
            bluetoothLocationAreEnable(context).then((value) {
              bleConnection.writeData(message.getMessage());
            })
        });
  }
}
