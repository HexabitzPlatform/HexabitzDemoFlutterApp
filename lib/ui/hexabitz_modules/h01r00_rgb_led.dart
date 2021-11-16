import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexabitz_demo_app/FLUTTER_WIRELESS_LIB/HexaInterface.dart';
import 'package:hexabitz_demo_app/FLUTTER_WIRELESS_LIB/Message.dart';
import 'package:hexabitz_demo_app/ui/item/custom_color_picker.dart';
import 'package:hexabitz_demo_app/ui/item/custom_int_picker.dart';
import 'package:hexabitz_demo_app/ui/item/custom_rolling_switch.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';

class RGBLedModule extends StatefulWidget {
  const RGBLedModule({Key key}) : super(key: key);

  @override
  _RGBLedModuleState createState() => _RGBLedModuleState();
}

class _RGBLedModuleState extends State<RGBLedModule> {
  int destination = 2, source = 1;
  List<int> message = [], payload = [];
  Color ledColor = Colors.transparent;
  int colorCode;

  bool isRunning = false;

  void _choseColor(Color color) {
    setState(() {
      ledColor = color;

      colorCode = HexaInterface.CODE_H01R0_COLOR;
      payload = [1, color.red, color.green, color.blue, color.alpha];
      if (isRunning)
        sendMessage(context, destination, source, colorCode, payload);
    });
  }

  void _setDestination(int value) {
    destination = value;
  }

  void _setSource(int value) {
    source = value;
  }

  CustomColorPicker _colorPicker;
  @override
  void initState() {
    super.initState();
    _colorPicker = CustomColorPicker(
      choseColor: _choseColor,
    );
  }

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
      title: Text(
        "Weight Module",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
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
                /*height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height -
                            appbar.preferredSize.height -
                            MediaQuery.of(context).padding.top
                        : 750,*/
                child: Column(
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
                              Stack(alignment: Alignment.center, children: [
                                Image.asset(
                                  "assets/images/module_h01r00_led.png",
                                  scale: 5,
                                ),
                                if (isRunning && ledColor != Colors.transparent)
                                  Transform.translate(
                                    offset: Offset(1, -1),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: ledColor.withOpacity(0.5),
                                              spreadRadius: 17,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: ledColor),
                                      height: 8,
                                      width: 8,
                                    ),
                                  )
                              ]),
                              Text(
                                "H01R00",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                          ),
                        ]),
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: _colorPicker),
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
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
                            print("destination=$destination");
                            print("source=$source");
                            //Use it to manage the different states
                            if (state && mounted) {
                              payload = [90];
                              colorCode = HexaInterface.CODE_H01R0_ON;
                              sendMessage(context, destination, source,
                                  colorCode, payload);
                            } else {
                              if (isRunning) {
                                payload = [0];
                                colorCode = HexaInterface.CODE_H01R0_OFF;
                                sendMessage(context, destination, source,
                                    colorCode, payload);
                              }
                            }
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => setState(() {
                                      isRunning = state;
                                    }));
                          },
                        ),
                      ),
                    )
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

    if (colorCode > 255)
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
    Message message = Message(destination, source, options, colorCode, payload);
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
