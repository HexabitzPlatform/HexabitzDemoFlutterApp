import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexabitz_demo_app/providers/wifi_connection_provider.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class WifiConnection extends StatefulWidget {
  const WifiConnection({Key key}) : super(key: key);

  @override
  _WifiConnectionState createState() => _WifiConnectionState();
}

class _WifiConnectionState extends State<WifiConnection> {
  final _ipController = TextEditingController(text: "192.168.1.4");
  final _portController = TextEditingController(text: "3333");
  bool _validateIpText = false, _validatePortText = false;
  @override
  Widget build(BuildContext context) {
    final wifiConnection = Provider.of<WIFIConnection>(context);
    if (wifiConnection.getIsReady) {
      connectionType = "WIFI";
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        return SecondScreen();
      }), (Route<dynamic> route) => false);
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          "Wifi Connection",
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 120,
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        controller: _ipController,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 10.0),
                          labelText: 'IP',
                          errorText:
                              _validateIpText ? 'IP Can\'t Be Empty' : null,
                          errorMaxLines: 50,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _portController,
                        maxLength: 5,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Port',
                          errorText:
                              _validatePortText ? 'Port Can\'t Be Empty' : null,
                          errorMaxLines: 50,
                          counterText: "",
                          contentPadding: new EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 10.0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(
                              color: Colors.orangeAccent,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orangeAccent)),
                    onPressed: () {
                      wifiConnection.setIP = _ipController.value.text;
                      wifiConnection.setPort = _portController.value.text;
                      wifiConnection.connectToDevice();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(11),
                      child: Text(
                        "Connect",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
