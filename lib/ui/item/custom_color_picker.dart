import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hexabitz_demo_app/database/init.dart';
import 'package:hexabitz_demo_app/database/recent_color_repository.dart';
import 'package:hexabitz_demo_app/models/recent_color.dart';
import 'package:flutter/cupertino.dart';

class CustomColorPicker extends StatefulWidget {
  final Function choseColor;
  CustomColorPicker({this.choseColor});

  @override
  _CustomColorPickerState createState() => _CustomColorPickerState();
}

class _CustomColorPickerState extends State<CustomColorPicker> {
  final Future _init = Init.initialize();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MyColorPicker(choseColor: widget.choseColor);
          } else {
            return Material(
              child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
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
                          child: CircularProgressIndicator()))),
            );
          }
        });
  }
}

class MyColorPicker extends StatefulWidget {
  final Function choseColor;
  const MyColorPicker({this.choseColor});

  @override
  _MyColorPickerState createState() => _MyColorPickerState();
}

class _MyColorPickerState extends State<MyColorPicker> {
  RecentColorRepository _recentColorRepository = GetIt.I.get();
  List<Color> recentColors;

  @override
  void initState() {
    super.initState();
    _loadRecentColor();
    recentColors = [
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
      Colors.black12,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
      recentColorsSubheading: Text(
        'Recent Colors',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showRecentColors: true,
      maxRecentColors: 8,
      recentColors: recentColors,
      onRecentColorsChanged: (List<Color> colors) {
        //putColorsInDatabase(colors);
        _editRecentColor(colors);
      },
      // Use the dialogPickerColor as start color.
      color: Colors.deepOrangeAccent,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) {
        // setState(() {})
        widget.choseColor(color);
        // print(color);
      },

      width: 40,
      height: 40,
      borderRadius: 8,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 200,
      wheelWidth: 10,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.wheel: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        //ColorPickerType.custom: true,
      },
      // customColorSwatchesAndNames: colorsNameMap,
    );
  }

  _loadRecentColor() async {
    final recentColor = await _recentColorRepository.getAllRecentColors();
    setState(() {
      if (recentColor.length == 0) {
        recentColors = [
          Colors.black12,
          Colors.black12,
          Colors.black12,
          Colors.black12,
          Colors.black12,
          Colors.black12,
          Colors.black12,
          Colors.black12,
        ];
        _addRecentColor(recentColors);
      } else {
        recentColors = recentColor.map((e) => Color(e.color)).toList();
      }
    });
  }

  _addRecentColor(List<Color> recentColors) async {
    recentColors.map((e) async {
      final color = e.value;
      final newRecentColor = RecentColor(color: color);
      await _recentColorRepository.insertRecentColor(newRecentColor);
    }).toList();
  }

  _editRecentColor(List<Color> colors) {
    int i = 1;

    colors.map((e) async {
      final updateRecentColor = RecentColor(id: i, color: e.value);
      i++;
      await _recentColorRepository.updateRecentColor(updateRecentColor);
    }).toList();
  }
}
