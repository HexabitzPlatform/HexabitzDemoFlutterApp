import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexabitz_demo_app/FLUTTER_WIRELESS_LIB/HexaInterface.dart';
import 'package:hexabitz_demo_app/providers/ble_connection_provider.dart';
import 'package:hexabitz_demo_app/providers/wifi_connection_provider.dart';
import 'package:hexabitz_demo_app/ui/item/custom_drop_down_from_field.dart';
import 'package:hexabitz_demo_app/ui/item/custom_int_picker.dart';
import 'package:hexabitz_demo_app/ui/item/custom_rolling_switch.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IRSensor extends StatefulWidget {
  const IRSensor({Key key}) : super(key: key);

  @override
  _IRSensorState createState() => _IRSensorState();
}

class _IRSensorState extends State<IRSensor> {
  String iRUnitCodeString = "MM";
  int destination = 2, source = 1, port = 6, module = 1;
  int iRUnitCode = HexaInterface.CODE_H26R0_STREAM_PORT_GRAM;
  bool isInfiniteTime = false;
  List<int> message = [], payload = [0];
  final _periodController = TextEditingController(text: "500");
  final _timeOutController = TextEditingController(text: "50000");
  bool _validatePeriodText = false, _validateTimeOutText = false;
  bool isBuild = false;
  //final weightStream = new StreamController.broadcast();
  String weight = "00.0";

  List<_ChartData> chartData = <_ChartData>[];
  Timer timer;
  ChartSeriesController _chartSeriesController;
// Count of type integer which binds as x value for the series
  int count = 1;
  bool isRunning = false;

  @override
  void dispose() {
    super.dispose();
    //weightStream.close();
    timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    chartData = <_ChartData>[_ChartData(0, 0)];

    //_timer = Timer.periodic(Duration(milliseconds: 60), _generateTrace);
/*         connection = WirelessConnection(
        bluetoothDevice: widget.bluetoothDevice,
        streamController: weightStream);*/
  }

  void _setDestination(int value) {
    destination = value;
  }

  void _setSource(int value) {
    source = value;
  }

  void _setPort(int value) {
    port = value;
  }

  void _setModule(int value) {
    module = value;
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
        "IR Sensor Module",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );

/*    weightStream.stream.listen((x) {
      //print(x);
      weight = x;
      //subject.sink.close();
    });*/
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
              Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height -
                            appbar.preferredSize.height -
                            MediaQuery.of(context).padding.top
                        : 600,
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              Image.asset(
                                "assets/images/module_h08r6_ir_sensor.png",
                                scale: 5,
                              ),
                              Text(
                                "H26R0",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                          Container(
                            width: 150,

                            //padding: EdgeInsets.all(10),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextFormField(
                                  enabled: !isInfiniteTime,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 5,
                                  controller: _periodController,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    counterText: "",
                                    contentPadding: new EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 10.0),
                                    labelText: 'Period (ms)',
                                    errorText: _validatePeriodText
                                        ? 'Period Can\'t Be Empty'
                                        : null,
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
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: TextFormField(
                                    enabled: !isInfiniteTime,
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
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: Colors.deepOrange,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        borderSide: BorderSide(
                                          color: Colors.orangeAccent,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          margin: EdgeInsets.only(top: 20),
                          child: CustomDropDownFormField(
                            titleText: 'Unit',
                            // contentPadding: EdgeInsets.all(20),
                            hintText: 'Please choose one',
                            required: true,
                            value: iRUnitCodeString,
                            onChanged: (value) {
                              setState(() {
                                iRUnitCodeString = value;
                                iRUnitCode = HexaInterface.CODE_H08R6_SET_UNIT;
                                switch (value) {
                                  case "MM":
                                    payload = [0];
                                    break;
                                  case "CM":
                                    payload = [1];
                                    break;
                                  case "Inch":
                                    payload = [2];
                                    break;
                                }
                              });
                            },
                            dataSource: [
                              {
                                "display": "MM",
                                "value": "MM",
                              },
                              {
                                "display": "CM",
                                "value": "CM",
                              },
                              {
                                "display": "Inch",
                                "value": "Inch",
                              }
                            ],
                            textField: 'display',
                            valueField: 'value',
                          ),
                        ),
                        Container(
                          height: 79,
                          padding: EdgeInsetsDirectional.only(top: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Infinite Time",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                CustomRollingSwitch(
                                  //initial value
                                  value: false,
                                  textOn: 'ON',
                                  textOff: 'OFF',
                                  colorOn: Colors.orangeAccent[700],
                                  colorOff: Colors.grey[700],
                                  iconOn: Icons.done,
                                  iconOff: Icons.remove_circle_outline,
                                  textSize: 16.0,
                                  onChanged: (bool state) {
                                    print(_periodController.text +
                                        "\n" +
                                        _timeOutController.text);
                                    if (isBuild)
                                      setState(() {
                                        isInfiniteTime = state;
                                      });
                                    isBuild = true;
                                    //Use it to manage the different states
                                    print('Current State of SWITCH IS: $state');
                                  },
                                ),
                              ]),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 5,
                      //margin: EdgeInsets.only(top: 60),
                      child: Align(
                        alignment: AlignmentDirectional.center,
                        child: Consumer2<BleConnection, WIFIConnection>(
                          builder: (ctx, bleConnection, wifiConnection, child) {
                            if (connectionType == "BLE") {
                              if (bleConnection.isThereValue)
                                _updateDataSource(bleConnection.getReadValue);
                            } else if (connectionType == "WIFI") {
                              if (wifiConnection.getIsThereValue)
                                _updateDataSource(wifiConnection.getReadValue);
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 150,
                                  width: 150,
                                  child: SfCartesianChart(
                                    primaryXAxis: NumericAxis(
                                        // X axis is hidden now
                                        isVisible: false),
                                    series: <LineSeries<_ChartData, int>>[
                                      LineSeries<_ChartData, int>(
                                        enableTooltip: true,
                                        onRendererCreated:
                                            (ChartSeriesController controller) {
                                          // Assigning the controller to the _chartSeriesController.
                                          _chartSeriesController = controller;
                                        },

                                        // Binding the chartData to the dataSource of the line series.
                                        dataSource: chartData,
                                        xValueMapper: (_ChartData sales, _) =>
                                            sales.country,
                                        yValueMapper: (_ChartData sales, _) =>
                                            sales.sales,
                                      )
                                    ],
                                  ),
                                ),
                                HexagonWidget.flat(
                                  width: 150,
                                  color: Colors.grey.withOpacity(0.18),
                                  padding: 4.0,
                                  child: Text(
                                    weight,
                                    style: GoogleFonts.odibeeSans(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      fontSize: 40,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      //margin: EdgeInsets.only(top: 60),
                      child: Align(
                          alignment: AlignmentDirectional.center,
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.orangeAccent)),
                                onPressed: () {
                                  iRUnitCode =
                                      HexaInterface.CODE_H08R6_SET_UNIT;
                                  sendMessage(context, destination, source,
                                      iRUnitCode, payload);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(11),
                                  child: Text(
                                    "Set Unit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20),
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
                                      /*timer = Timer.periodic(
                                          const Duration(milliseconds: 500),
                                          _updateDataSource);*/
                                      setState(() {
                                        if (_periodController.text.isEmpty) {
                                          _validatePeriodText = true;
                                        } else
                                          _validatePeriodText = false;
                                        if (_timeOutController.text.isEmpty) {
                                          _validateTimeOutText = true;
                                        } else
                                          _validateTimeOutText = false;
                                      });
                                      if (_validatePeriodText ||
                                          _validateTimeOutText) return;
                                      iRUnitCode =
                                          HexaInterface.CODE_H08R6_STREAM_PORT;
                                      Uint32List period =
                                          new Uint32List.fromList([
                                        int.parse(_periodController.text)
                                      ]);
                                      Uint8List periodBytes =
                                          new Uint8List.view(period.buffer);
                                      Uint32List time = new Uint32List.fromList(
                                          [int.parse(_timeOutController.text)]);
                                      Uint8List timeBytes =
                                          new Uint8List.view(time.buffer);
                                      if (isInfiniteTime)
                                        timeBytes = Uint8List.fromList(
                                            [255, 255, 255, 255]);
                                      payload = [
                                        port,
                                        module,
                                        periodBytes[3],
                                        periodBytes[2],
                                        periodBytes[1],
                                        periodBytes[0],
                                        timeBytes[3],
                                        timeBytes[2],
                                        timeBytes[1],
                                        timeBytes[0],
                                      ];
                                      sendMessage(context, destination, source,
                                          iRUnitCode, payload);
                                      print(payload);
                                    } else {
                                      // timer?.cancel();
                                      if (isRunning) {
                                        iRUnitCode = HexaInterface
                                            .CODE_H08R6_STOP_RANGING;
                                        payload = [0];
                                        sendMessage(context, destination,
                                            source, iRUnitCode, payload);
                                      }
                                    }
                                    isRunning = state;
                                  },
                                ),
                              ),
                            ],
                          )),
                    )
                    /* DropdownButton<String>(
                    value: _chosenValue,
                    //elevation: 5,
                    style: TextStyle(color: Colors.black),

                    items: <String>[
                      'Android',
                      'IOS',
                      'Flutter',
                      'Node',
                      'Java',
                      'Python',
                      'PHP',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text(
                      "Please choose a langauage",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  ),*/
                  ],
                ),
              )
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

    if (iRUnitCode > 255)
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
    // print("iRUnitCode:$iRUnitCode");
    Message message =
        Message(destination, source, options, iRUnitCode, payload);
    /////////////////////////////////////////
    //List<int> z = [];

    //connection.sendMessage(message.getMessage());
    //connection.test();

    //print("Message: ${message.getMessage()}");
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
                  setDestination: _setDestination,
                  port: port,
                  setPort: _setPort,
                  module: module,
                  setModule: _setModule,
                ),
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

/*  void _updateDataSource(Timer timer) {
    int x = _getRandomInt(10, 100);
    setState(() {
      weight = x.toString();
    });

    chartData.add(_ChartData(count, x));
    if (chartData.length == 20) {
      // Removes the last index data of data source.
      chartData.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
          removedDataIndexes: <int>[0]);
    }
    count = count + 1;
  }*/
  void _updateDataSource(String value) {
    //int x = _getRandomInt(10, 100);
    weight = value;

    chartData.add(_ChartData(count, double.parse(value).round()));
    if (chartData.length == 20) {
      // Removes the last index data of data source.
      chartData.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesController?.updateDataSource(
          addedDataIndexes: <int>[chartData.length - 1],
          removedDataIndexes: <int>[0]);
    }
    count = count + 1;
  }

/*  num _getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }*/
}

class _ChartData {
  _ChartData(this.country, this.sales);
  final int country;
  final num sales;
}
