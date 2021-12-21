import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get_it/get_it.dart';
import 'package:hexabitz_demo_app/database/bluetooth_device_repo/bluetooth_device_repo.dart';
import 'package:hexabitz_demo_app/providers/ble_connection_provider.dart';
import 'package:hexabitz_demo_app/ui/item/custom%20_progress_button.dart';
import 'package:hexabitz_demo_app/models/bluetooth_device_item.dart'
    as BLEDevice;
import 'package:hexabitz_demo_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

class BluetoothConnection extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];
  final Map<Guid, List<int>> readValues = new Map<Guid, List<int>>();

  @override
  _BluetoothConnectionState createState() => _BluetoothConnectionState();
}

class _BluetoothConnectionState extends State<BluetoothConnection> {
  final _writeController = TextEditingController();
  // late BluetoothDevice _connectedDevice;
  List<BluetoothService> _services;
  bool isSearching = false;
  bool isTryToConnect = false;

  //for store BLE device name
  BluetoothDeviceRepo _bluetoothDeviceRepo = GetIt.I.get();
  List<BLEDevice.BluetoothDevice> _bluetoothDevice = [];
  List<BLEDevice.BluetoothDevice> _bluetoothDeviceNow = [];
  List<bool> _bluetoothDeviceHasName = [];

  _addDeviceToList(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      widget.devicesList.add(device);
    }
    setState(() {});
  }

  @override
  void dispose() {
    widget.flutterBlue.stopScan();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceToList(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        if (this.mounted) _addDeviceToList(result.device);
      }
    });
    // widget.flutterBlue.startScan();
    _loadBluetoothDevices();
    isSearching = true;
    Timer(Duration(seconds: 3), () {
      scanBluetoothDevices();
    });
  }

  _loadBluetoothDevices() async {
    final devices = await _bluetoothDeviceRepo.getAllCakes();
    setState(() => _bluetoothDevice = devices);
  }

  void scanBluetoothDevices() {
    widget.flutterBlue.stopScan();
    widget.flutterBlue.startScan();
    print("XXXXXXXXXXXXXXXXXXx");
    setState(() {
      isSearching = true;
    });

    Timer(Duration(seconds: 15), () {
      print("Yeah, this line is printed after 10 seconds");
      widget.flutterBlue.stopScan();
      setState(() {
        isSearching = false;
      });
    });
  }

  ListView _buildListViewOfDevices(BleConnection bleConnection) {
    _bluetoothDeviceHasName = [];
    _bluetoothDeviceNow = [];
    for (int i = 0; i < widget.devicesList.length; i++) {
      _bluetoothDeviceHasName.add(false);
      _bluetoothDeviceNow.add(BLEDevice.BluetoothDevice(
          id: i,
          deviceId: widget.devicesList[i].id.toString(),
          name: widget.devicesList[i].name));
      for (int j = 0; j < _bluetoothDevice.length; j++) {
        if (widget.devicesList[i].id.toString() ==
            _bluetoothDevice[j].deviceId) {
          _bluetoothDeviceHasName[i] = true;
          _bluetoothDeviceNow[i].name = _bluetoothDevice[j].name;
        }
      }
    }
    List<Container> containers = [];
    print("yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy");
    print(widget.devicesList.length);
    for (BluetoothDevice device in widget.devicesList) {
      print("xzzzzzzzzzzzzzzzzzzzzzzzzz");
      containers.add(
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Row(
            children: <Widget>[
              Container(
                child: CircleAvatar(
                  child: Icon(
                    Icons.bluetooth,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onLongPress: () =>
                      _showNameDeviceDialog(widget.devicesList.indexOf(device)),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _bluetoothDeviceHasName[
                                widget.devicesList.indexOf(device)]
                            ? "${_bluetoothDeviceNow[widget.devicesList.indexOf(device)].name}"
                            : device.name == ''
                                ? '(unknown device)'
                                : device.name,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        device.id.toString(),
                        style: TextStyle(fontSize: Platform.isIOS ? 10 : null),
                      ),
                    ],
                  ),
                ),
              ),
              CustomProgressButton(
                onTap: () async {
                  widget.flutterBlue.stopScan();
                  if (!isTryToConnect) {
                    setState(() {
                      isTryToConnect = true;
                      isSearching = false;
                    });

                    try {
                      //await device.connect();
                      await bleConnection.connectToDevice(device);
                    } catch (e) {
                      if (e != 'already_connected') {
                        throw e;
                      }
                    } finally {
                      // _services = await device.discoverServices();
/*                      if (!_bluetoothDeviceHasName[
                          widget.devicesList.indexOf(device)])
                        _showNameDeviceDialog(
                            widget.devicesList.indexOf(device));*/
                      setState(() {
                        isTryToConnect = false;
                      });
                    }
/*                    setState(() {
                      // _connectedDevice = device;
                    });*/
                  }
                },
                isConnect: /*_isConnect*/ (device == bleConnection.bleDevice &&
                        bleConnection.isReady)
                    ? true
                    : false,
                buttonText: "Connect",
              ),
              /* TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orangeAccent)),
                child: Text(
                  'Connect',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  widget.flutterBlue.stopScan();

                  try {
                    await device.connect();
                  } catch (e) {
                    if (e != 'already_connected') {
                      throw e;
                    }
                  } finally {
                    // _services = await device.discoverServices();

                  }
                  setState(() {
                    // _connectedDevice = device;
                  });
                },
              ),*/
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  List<ButtonTheme> _buildReadWriteNotifyButton(
      BluetoothCharacteristic characteristic) {
    List<ButtonTheme> buttons = [];

    if (characteristic.properties.read) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue)),
              child: Text('READ', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                var sub = characteristic.value.listen((value) {
                  setState(() {
                    widget.readValues[characteristic.uuid] = value;
                  });
                });
                await characteristic.read();
                sub.cancel();
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.write) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('WRITE', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Write"),
                        content: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _writeController,
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("Send"),
                            onPressed: () {
                              characteristic.write(
                                  utf8.encode(_writeController.value.text));
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ),
      );
    }
    if (characteristic.properties.notify) {
      buttons.add(
        ButtonTheme(
          minWidth: 10,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              child: Text('NOTIFY', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                characteristic.value.listen((value) {
                  widget.readValues[characteristic.uuid] = value;
                });
                await characteristic.setNotifyValue(true);
              },
            ),
          ),
        ),
      );
    }

    return buttons;
  }

  ListView _buildConnectDeviceView() {
    List<Container> containers = [];

    for (BluetoothService service in _services) {
      List<Widget> characteristicsWidget = [];

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        characteristicsWidget.add(
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(characteristic.uuid.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: <Widget>[
                    ..._buildReadWriteNotifyButton(characteristic),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('Value: ' +
                        widget.readValues[characteristic.uuid].toString()),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      }
      containers.add(
        Container(
          child: ExpansionTile(
              title: Text(service.uuid.toString()),
              children: characteristicsWidget),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...containers,
      ],
    );
  }

  ListView _buildView(BleConnection bleConnection) {
    /*  if (_isConnect) {
      return _buildConnectDeviceView();
    }*/
    return _buildListViewOfDevices(bleConnection);
  }

  void _showNameDeviceDialog(int index) {
    final bool _validateNameText = false;
    BluetoothDevice device = widget.devicesList[index];
    String name = _bluetoothDeviceHasName[index]
        ? "${_bluetoothDeviceNow[index].name}"
        : device.name == ''
            ? " (unknown device)"
            : device.name;
    final _deviceNameController = TextEditingController(text: name);
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 200,
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            padding: EdgeInsets.only(top: 15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1.0),
              borderRadius: BorderRadius.circular(40),
            ),
            child: SizedBox.expand(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Module name",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 250,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _deviceNameController,
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontSize: 18),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 10.0),
                          labelText: "Name",
                          errorText:
                              _validateNameText ? "Name already exists" : null,
                          errorMaxLines: 50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.blueGrey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Divider(
                          thickness: 2,
                          height: 1,
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(40)),
                              onTap: () => Navigator.of(context).pop(),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 40,
                                  width: ((MediaQuery.of(context).size.width -
                                          24 -
                                          1) /
                                      2),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                thickness: 2,
                                width: 1,
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(40)),
                              onTap: () async {
                                if (_deviceNameController.text.trim().isEmpty)
                                  Navigator.of(context).pop();
                                else {
                                  BLEDevice.BluetoothDevice bleDevice =
                                      BLEDevice.BluetoothDevice(
                                          name: _deviceNameController.text,
                                          deviceId: widget.devicesList[index].id
                                              .toString());

                                  if (!_bluetoothDeviceHasName[index])
                                    await _bluetoothDeviceRepo
                                        .insertDevice(bleDevice);
                                  else {
                                    BLEDevice.BluetoothDevice updatedBleDevice;
                                    for (int i = 0;
                                        i < widget.devicesList.length;
                                        i++) {
                                      for (int j = 0;
                                          j < _bluetoothDevice.length;
                                          j++) {
                                        if (widget.devicesList[i].id
                                                .toString()
                                                .compareTo(_bluetoothDevice[j]
                                                    .deviceId) ==
                                            0)
                                          updatedBleDevice = _bluetoothDevice[j]
                                              .copyWith(
                                                  name: _deviceNameController
                                                      .text);
                                      }
                                    }
                                    await _bluetoothDeviceRepo
                                        .updateDevice(updatedBleDevice);
                                  }
                                  _bluetoothDeviceHasName[index] = true;
                                  _bluetoothDeviceNow[index].name =
                                      _deviceNameController.text;
                                  _loadBluetoothDevices();
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: ((MediaQuery.of(context).size.width -
                                        24 -
                                        1) /
                                    2),
                                height: 40,
                                child: Text(
                                  "Save",
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bleConnection = Provider.of<BleConnection>(context);
    if (bleConnection.isReady) {
      isTryToConnect = false;
      connectionType = "BLE";
    }
    AppBar appBar = AppBar(
      actions: <Widget>[
        if (isSearching || isTryToConnect)
          Container(
            width: 60,
            height: 40,
            padding: EdgeInsets.all(18),
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3.0,
            ),
          )
      ],
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text(
        "Bluetooth Connection",
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(-0.4, -0.8),
              stops: [0.0, 0.5, 0.5, 1],
              colors: [
                Colors.white38,
                Colors.white,
                Colors.white38,
                Colors.white,
              ],
              tileMode: TileMode.repeated,
            ),
          ),
          child: Column(
            children: [
              Hero(
                tag: "bluetoothLogo",
                child: Icon(
                  Icons.bluetooth,
                  color: Colors.orange,
                  size: 50,
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).viewInsets.bottom -
                      80,
                  child: _buildView(bleConnection)),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!isSearching) scanBluetoothDevices();
        },
        tooltip: 'Research',
        backgroundColor:
            isSearching ? Colors.grey : Theme.of(context).primaryColor,
        child: Icon(
          Icons.search_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
