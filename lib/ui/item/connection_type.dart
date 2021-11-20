import 'package:flutter/material.dart';
import 'package:hexabitz_demo_app/connection/bluetooth/BluetoothConnection.dart';
import 'package:hexabitz_demo_app/connection/wifi/WifiConnection.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart' as Utilities;

class ConnectionType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final connectionType = Utilities.connectionType;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Connection Type",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Container(
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
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            Card(
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Utilities.checkPermission(context).then((value1) => {
                        if (value1)
                          Utilities.bluetoothLocationAreEnable(context)
                              .then((value2) => {
                                    if (value2)
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(builder: (_) {
                                        return BluetoothConnection();
                                      }))
                                  })
                      });
                },
                child: Container(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(
                            Icons.bluetooth,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Bluetooth",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(45, 62, 95, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: connectionType == "BLE"
                                  ? Colors.greenAccent
                                  : Colors.grey),
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return WifiConnection();
                  }));
                },
                child: Container(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(
                            Icons.wifi,
                            color: Colors.orangeAccent,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "WIFI",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromRGBO(45, 62, 95, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: connectionType == "WIFI"
                                  ? Colors.greenAccent
                                  : Colors.grey),
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
