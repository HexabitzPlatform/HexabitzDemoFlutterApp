import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hexabitz_demo_app/FLUTTER_WIRELESS_LIB/HexaInterface.dart';
import 'package:hexabitz_demo_app/FLUTTER_WIRELESS_LIB/Message.dart';
import 'package:hexabitz_demo_app/ui/item/custom_int_picker.dart';
import 'package:hexabitz_demo_app/ui/item/custom_rolling_switch.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';

class RelayACModules extends StatefulWidget {
  const RelayACModules({Key key}) : super(key: key);

  @override
  _RelayACModulesState createState() => _RelayACModulesState();
}

class _RelayACModulesState extends State<RelayACModules> {
  final _timeOutController = TextEditingController(text: "2000");

  int relayUnitCode = HexaInterface.CODE_H0FR6_TOGGLE;
  List<int> message = [], payload = [];

  bool _validateTimeOutText = false;

  int destination = 2, source = 1;

  bool isRunning = false;
  void _setDestination(int value) {
    destination = value;
  }

  void _setSource(int value) {
    source = value;
  }

  @override
  Widget build(BuildContext context) {
    final appbar = AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            // do something
            _showDialog();
          },
        )
      ],
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      centerTitle: true,
      title: Text(
        "Relay AC Module",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
    return Scaffold(
      appBar: appbar,
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
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(children: [
                            Image.asset(
                              "assets/images/module_h09r00_relay.png",
                              scale: 3.5,
                            ),
                            Text(
                              "H0FR60",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                        ),
                      ]),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: TextFormField(
                        autofocus: false,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: _timeOutController,
                        maxLength: 5,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          labelText: 'Time Out (ms)',
                          errorText: _validateTimeOutText
                              ? 'Time Out Can\'t Be Empty'
                              : null,
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
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: CustomRollingSwitch(
                        //initial value
                        value: false,
                        textOn: 'ON',
                        textOff: 'OFF',
                        colorOn: Colors.green[400],
                        colorOff: Colors.red[400],
                        iconOn: Icons.done,
                        iconOff: Icons.remove_circle_outline,
                        textSize: 16.0,
                        onChanged: (bool state) {
                          //Use it to manage the different states
                          if (state) {
                            setState(() {
                              if (_timeOutController.text.isEmpty) {
                                _validateTimeOutText = true;
                              } else
                                _validateTimeOutText = false;
                            });
                            if (_validateTimeOutText) return;
                            relayUnitCode = HexaInterface.CODE_H0FR6_ON;
                            Uint32List time = new Uint32List.fromList(
                                [int.parse(_timeOutController.text)]);
                            Uint8List timeBytes =
                                new Uint8List.view(time.buffer);
                            payload = [
                              timeBytes[0],
                              timeBytes[1],
                              timeBytes[2],
                              timeBytes[3],
                            ];
                            sendMessage(context, destination, source,
                                relayUnitCode, payload);
                            print(payload);
                          } else {
                            if (isRunning) {
                              relayUnitCode = HexaInterface.CODE_H0FR6_TOGGLE;
                              payload = [];
                              sendMessage(context, destination, source,
                                  relayUnitCode, payload);
                            }
                            isRunning = state;
                          }
                        },
                      ),
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*  void sendMessage() {
    String opt8NextMessage = "0";
    String opt67ResponseOptions = "01";
    String opt5Reserved = "0";
    String opt34TraceOptions = "00";
    String opt2_16BITCode = "0";
    String opt1ExtendedFlag = "0";

    if (relayUnitCode > 255)
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
    Message message =
        Message(destination, source, options, relayUnitCode, payload);
    /////////////////////////////////////////
    //List<int> z = [];

    //connection.sendMessage(message.getMessage());
    //connection.test();

    message.getMessage();
  }*/

  void _showDialog() {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Container(
            height: 350,
            child: SizedBox.expand(
                child: Column(
              children: [
                CustomIntegerPicker(
                    source: source,
                    setSource: _setSource,
                    destination: destination,
                    setDestination: _setDestination),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  /*  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue)),*/
                  child: Text('Finish',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
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
}
