import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexabitz_demo_app/providers/wifi_connection_provider.dart';
import 'package:hexabitz_demo_app/ui/hexabitz_cells_screen.dart';
import 'package:hexabitz_demo_app/ui/item/connection_type.dart';
import 'package:hexabitz_demo_app/ui/splash_screen.dart';
import 'package:provider/provider.dart';
import 'connection/bluetooth/BluetoothConnection.dart';
import 'database/init.dart';
import 'providers/ble_connection_provider.dart';
import 'package:hexabitz_demo_app/utilities/utilities.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (ctx) => BleConnection(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => WIFIConnection(),
      ),
    ],
    child: MyApp(),
  ));
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black38,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {"/connection-type": (context) => ConnectionType()},
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SecondScreen())));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SplashScreen();
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  bool thereIsBluetoothConnection = false;

  @override
  void initState() {
    super.initState();
    thereIsBluetoothConnection = true;
    Init.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Hexabitz Demo App",
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
        child: thereIsBluetoothConnection
            ? HexabitzCellsScreen()
            : CircleAvatar(
                child: Icon(
                  Icons.bluetooth_disabled,
                  color: Colors.orangeAccent,
                ),
              ),
      )),
      floatingActionButton: OpenContainer(
          closedBuilder: (BuildContext c, VoidCallback action) {
            return FloatingActionButton(
              isExtended: true,
              onPressed: () => action(),
              child: Icon(
                connectionType == "BLE"
                    ? Icons.bluetooth_connected
                    : connectionType == "WIFI"
                        ? Icons.wifi
                        : Icons.wifi_tethering_off,
                color: Colors.white,
              ),
              tooltip: 'Bluetooth connection',
            );
/*              FloatingActionButton(
              elevation: 0.0,
              onPressed: openContainer,
              backgroundColor: Colors.blue,
              child: Icon(Icons.add, color: Colors.white),
            );*/
          },
          openColor: Colors.white,
          closedElevation: 5.0,
          closedShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          closedColor: Colors.orange,
          tappable: false,
          transitionDuration: Duration(milliseconds: 800),
          openBuilder: (_, closeContainer) {
            return ConnectionType();
          }),
    );
  }

  void bluetoothConnection(BuildContext ctx) {
    Navigator.of(ctx).push(PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 700),
        pageBuilder: (_, __, ___) {
          return BluetoothConnection();
        }));
  }

/*  static Route<T> fadeThrough<T>(PageBuilder page,
      [double duration = kDefaultDuration]) {
    return PageRouteBuilder<T>(
      transitionDuration: Duration(milliseconds: (duration * 1000).round()),
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child);
      },
    );
  }

  static Route<T> fadeScale<T>(PageBuilder page,
      [double duration = kDefaultDuration]) {
    return PageRouteBuilder<T>(
      transitionDuration: Duration(milliseconds: (duration * 1000).round()),
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(animation: animation, child: child);
      },
    );
  }

  static Route<T> sharedAxis<T>(PageBuilder page,
      [SharedAxisTransitionType type = SharedAxisTransitionType.scaled,
      double duration = kDefaultDuration]) {
    return PageRouteBuilder<T>(
      transitionDuration: Duration(milliseconds: (duration * 1000).round()),
      pageBuilder: (context, animation, secondaryAnimation) => page(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SharedAxisTransition(
          child: child,
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
        );
      },
    );
  }*/
}
