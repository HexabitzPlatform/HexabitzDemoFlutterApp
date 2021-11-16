import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:hexabitz_demo_app/FLUTTER_WIRELESS_LIB/HexaInterface.dart';
import 'package:hexabitz_demo_app/providers/ble_connection_provider.dart';
import 'package:hexabitz_demo_app/ui/item/custom_drop_down_from_field.dart';
import 'package:hexabitz_demo_app/ui/item/custom_int_picker.dart';
import 'package:hexabitz_demo_app/ui/item/custom_rolling_switch.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IMUModule extends StatefulWidget {
  const IMUModule({Key key}) : super(key: key);

  @override
  _IMUModuleState createState() => _IMUModuleState();
}

class _IMUModuleState extends State<IMUModule> {
  String iMUUnitCodeString = "Gyroscope";
  int destination = 2, source = 1;
  int iMUUnitCode = HexaInterface.CODE_H0BR4_STREAM_GYRO;
  bool isInfiniteTime = false;
  List<int> message = [], payload = [0];
  final _periodController = TextEditingController(text: "500");
  final _timeOutController = TextEditingController(text: "50000");
  bool _validatePeriodText = false, _validateTimeOutText = false;
  bool isBuild = false;
  //final weightStream = new StreamController.broadcast();
  String weight = "00.0";
  bool isRunning = false;

  List<_ChartData> chartDataX = <_ChartData>[];
  List<_ChartData> chartDataY = <_ChartData>[];
  List<_ChartData> chartDataZ = <_ChartData>[];
  Timer timer;
  ChartSeriesController _chartSeriesControllerX,
      _chartSeriesControllerY,
      _chartSeriesControllerZ;
// Count of type integer which binds as x value for the series
  int count = 1;
  TextEditingController _xController = TextEditingController(text: "0.0");
  TextEditingController _yController = TextEditingController(text: "0.0");
  TextEditingController _zController = TextEditingController(text: "0.0");
  void _setDestination(int value) {
    destination = value;
  }

  void _setSource(int value) {
    source = value;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
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
        "IMU Sensor Module",
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
                                "assets/images/module_h0br40_imu.png",
                                scale: 4,
                              ),
                              Text(
                                "H0BR40",
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
                            value: iMUUnitCodeString,
                            onChanged: (value) {
                              setState(() {
                                iMUUnitCodeString = value;
                                switch (value) {
                                  case "Gyroscope":
                                    iMUUnitCode =
                                        HexaInterface.CODE_H0BR4_STREAM_GYRO;
                                    break;
                                  case "Accelerometer":
                                    iMUUnitCode =
                                        HexaInterface.CODE_H0BR4_STREAM_ACC;
                                    break;
                                  case "Magnetometer":
                                    iMUUnitCode =
                                        HexaInterface.CODE_H0BR4_STREAM_MAG;
                                    break;
                                }
                              });
                              if (isRunning) sentData();
                            },
                            dataSource: [
                              {
                                "display": "Gyroscope",
                                "value": "Gyroscope",
                              },
                              {
                                "display": "Accelerometer",
                                "value": "Accelerometer",
                              },
                              {
                                "display": "Magnetometer",
                                "value": "Magnetometer",
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
                        child: Consumer<BleConnection>(
                          builder: (ctx, bleConnection, child) {
                            /* if (bleConnection.isThereValue)
                              _updateDataSource(bleConnection.getIMUValue);*/
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  child: SfCartesianChart(
                                    trackballBehavior: TrackballBehavior(
                                        enable: true,
                                        activationMode:
                                            ActivationMode.singleTap),
                                    // Enable legend
                                    legend: Legend(isVisible: true),
                                    primaryXAxis: NumericAxis(
                                        // X axis is hidden now
                                        isVisible: true),
                                    series: <LineSeries<_ChartData, int>>[
                                      LineSeries<_ChartData, int>(
                                        //markerSettings: MarkerSettings(isVisible: true,),
                                        name: "X",
                                        color: Colors.red,
                                        enableTooltip: true,
                                        onRendererCreated:
                                            (ChartSeriesController controller) {
                                          // Assigning the controller to the _chartSeriesController.
                                          _chartSeriesControllerX = controller;
                                        },

                                        // Binding the chartData to the dataSource of the line series.
                                        dataSource: chartDataX,
                                        xValueMapper: (_ChartData sales, _) =>
                                            sales.country,
                                        yValueMapper: (_ChartData sales, _) =>
                                            sales.sales,
                                      ),
                                      LineSeries<_ChartData, int>(
                                        name: "Y",
                                        color: Colors.blue,
                                        enableTooltip: true,
                                        onRendererCreated:
                                            (ChartSeriesController controller) {
                                          // Assigning the controller to the _chartSeriesController.
                                          _chartSeriesControllerY = controller;
                                        },

                                        // Binding the chartData to the dataSource of the line series.
                                        dataSource: chartDataY,
                                        xValueMapper: (_ChartData sales, _) =>
                                            sales.country,
                                        yValueMapper: (_ChartData sales, _) =>
                                            sales.sales,
                                      ),
                                      LineSeries<_ChartData, int>(
                                        name: "Z",
                                        color: Colors.green,
                                        enableTooltip: true,
                                        onRendererCreated:
                                            (ChartSeriesController controller) {
                                          // Assigning the controller to the _chartSeriesController.
                                          _chartSeriesControllerZ = controller;
                                        },

                                        // Binding the chartData to the dataSource of the line series.
                                        dataSource: chartDataZ,
                                        xValueMapper: (_ChartData sales, _) =>
                                            sales.country,
                                        yValueMapper: (_ChartData sales, _) =>
                                            sales.sales,
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 75,
                                      child: TextFormField(
                                        readOnly: true,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: _xController,
                                        decoration: InputDecoration(
                                          labelText: 'X',
                                          errorMaxLines: 50,
                                          counterText: "",
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 10.0),
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
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 75,
                                      child: TextFormField(
                                        readOnly: true,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: _yController,
                                        decoration: InputDecoration(
                                          labelText: 'Y',
                                          errorMaxLines: 50,
                                          counterText: "",
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 10.0),
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
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 75,
                                      child: TextFormField(
                                        readOnly: true,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        controller: _zController,
                                        decoration: InputDecoration(
                                          labelText: 'Z',
                                          errorMaxLines: 50,
                                          counterText: "",
                                          contentPadding:
                                              new EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 10.0),
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
                                    ),
                                  ],
                                )
/*                                HexagonWidget.flat(
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
                                ),*/
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      //margin: EdgeInsets.only(top: 60),
                      child: Align(
                          alignment: AlignmentDirectional.center,
                          child: Column(
                            children: [
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
                                      timer = Timer.periodic(
                                          const Duration(milliseconds: 500),
                                          _updateDataSource);

                                      sentData();
                                      print(payload);
                                    } else {
                                      if (isRunning) {
                                        timer?.cancel();
                                        iMUUnitCode = HexaInterface
                                            .CODE_H0BR4_STREAM_STOP;
                                        payload = [0];
                                        sendMessage(context, destination,
                                            source, iMUUnitCode, payload);
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
              /*              Expanded(
                flex: 1,
                child: Center(
                  child: AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'coming soon',
                        speed: const Duration(milliseconds: 250),
                        textStyle: GoogleFonts.abrilFatface(
                            textStyle: Theme.of(context).textTheme.headline4,
                            fontSize: 40,
                            color: Colors.orangeAccent
                            //fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 20,
                  ))*/
            ],
          ),
        ),
      ),
    );
  }

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

/*  void _updateDataSource(List<String> data) {
    int x = double.parse(data[0]).round();
    int y = double.parse(data[1]).round();
    int z = double.parse(data[2]).round();
    setState(() {
      _xController = TextEditingController(text: x.toString());
      _yController = TextEditingController(text: y.toString());
      _zController = TextEditingController(text: z.toString());
    });
    chartDataX.add(_ChartData(count, x));
    if (chartDataX.length == 20) {
      // Removes the last index data of data source.
      chartDataX.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesControllerX?.updateDataSource(
          addedDataIndexes: <int>[chartDataX.length - 1],
          removedDataIndexes: <int>[0]);
    }
    chartDataY.add(_ChartData(count, y));
    if (chartDataY.length == 20) {
      // Removes the last index data of data source.
      chartDataY.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesControllerY?.updateDataSource(
          addedDataIndexes: <int>[chartDataY.length - 1],
          removedDataIndexes: <int>[0]);
    }
    chartDataZ.add(_ChartData(count, z));
    if (chartDataZ.length == 20) {
      // Removes the last index data of data source.
      chartDataZ.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesControllerZ?.updateDataSource(
          addedDataIndexes: <int>[chartDataZ.length - 1],
          removedDataIndexes: <int>[0]);
    }
    count = count + 1;
  }*/
  void _updateDataSource(Timer timer) {
    int x = _getRandomInt(10, 100);
    int y = _getRandomInt(10, 100);
    int z = _getRandomInt(10, 100);
    setState(() {
      _xController = TextEditingController(text: x.toString());
      _yController = TextEditingController(text: y.toString());
      _zController = TextEditingController(text: z.toString());
    });
    chartDataX.add(_ChartData(count, x));
    if (chartDataX.length == 20) {
      // Removes the last index data of data source.
      chartDataX.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesControllerX?.updateDataSource(
          addedDataIndexes: <int>[chartDataX.length - 1],
          removedDataIndexes: <int>[0]);
    }
    chartDataY.add(_ChartData(count, y));
    if (chartDataY.length == 20) {
      // Removes the last index data of data source.
      chartDataY.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesControllerY?.updateDataSource(
          addedDataIndexes: <int>[chartDataY.length - 1],
          removedDataIndexes: <int>[0]);
    }
    chartDataZ.add(_ChartData(count, z));
    if (chartDataZ.length == 20) {
      // Removes the last index data of data source.
      chartDataZ.removeAt(0);
      // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
      _chartSeriesControllerZ?.updateDataSource(
          addedDataIndexes: <int>[chartDataZ.length - 1],
          removedDataIndexes: <int>[0]);
    }
    count = count + 1;
  }

  num _getRandomInt(num min, num max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void sentData() {
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
    if (_validatePeriodText || _validateTimeOutText) return;
    Uint32List period =
        new Uint32List.fromList([int.parse(_periodController.text)]);
    Uint8List periodBytes = new Uint8List.view(period.buffer);
    Uint32List time =
        new Uint32List.fromList([int.parse(_timeOutController.text)]);
    Uint8List timeBytes = new Uint8List.view(time.buffer);
    if (isInfiniteTime) timeBytes = Uint8List.fromList([255, 255, 255, 255]);
    //port , module ,periodBytes,
    payload = [
      periodBytes[3],
      periodBytes[2],
      periodBytes[1],
      periodBytes[0],
      timeBytes[3],
      timeBytes[2],
      timeBytes[1],
      timeBytes[0],
      6,
      1
    ];
    sendMessage(context, destination, source, iMUUnitCode, payload);
  }
}

class _ChartData {
  _ChartData(this.country, this.sales);
  final int country;
  final num sales;
}
