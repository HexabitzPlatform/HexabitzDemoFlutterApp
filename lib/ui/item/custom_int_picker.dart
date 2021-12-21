import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomIntegerPicker extends StatefulWidget {
  final Function setSource;
  final Function setDestination;
  final Function setPort;
  final Function setModule;
  final int source;
  final int destination;
  final int port;
  final int module;
  CustomIntegerPicker(
      {this.source,
      this.setSource,
      this.destination,
      this.setDestination,
      this.port,
      this.setPort,
      this.module,
      this.setModule});
  @override
  __CustomIntegerPickerState createState() => __CustomIntegerPickerState();
}

class __CustomIntegerPickerState extends State<CustomIntegerPicker> {
  int _currentSourceValue;
  int _currentDestinationValue;
  int _currentPortValue;
  int _currentModuleValue;

  @override
  void initState() {
    super.initState();
    _currentSourceValue = widget.source;
    _currentDestinationValue = widget.destination;
    _currentPortValue = widget.port;
    _currentModuleValue = widget.module;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(children: [
          SizedBox(height: 16),
          Text('Source',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.orangeAccent, fontSize: 18)),
          NumberPicker(
            value: _currentSourceValue,
            minValue: 1,
            maxValue: 9,
            step: 1,
            itemHeight: 80,
            itemWidth: 65,
            infiniteLoop: true,
            selectedTextStyle: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).accentColor, fontSize: 25),
            textStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 21),
            onChanged: (value) => setState(() {
              _currentSourceValue = value;
              widget.setSource(value);
            }),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black26),
            ),
          ),
        ]),
        Column(children: [
          SizedBox(height: 16),
          Text('Destination',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.orangeAccent, fontSize: 18)),
          NumberPicker(
            value: _currentDestinationValue,
            minValue: 1,
            maxValue: 9,
            step: 1,
            itemHeight: 80,
            itemWidth: 65,
            infiniteLoop: true,
            selectedTextStyle: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).accentColor, fontSize: 25),
            textStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 21),
            onChanged: (value) => setState(() {
              _currentDestinationValue = value;
              widget.setDestination(value);
            }),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black26),
            ),
          ),
        ]),
        Column(children: [
          SizedBox(height: 16),
          Text('Port',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.orangeAccent, fontSize: 18)),
          NumberPicker(
            value: _currentPortValue,
            minValue: 1,
            maxValue: 6,
            step: 1,
            itemHeight: 80,
            itemWidth: 65,
            infiniteLoop: true,
            selectedTextStyle: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).accentColor, fontSize: 25),
            textStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 21),
            onChanged: (value) => setState(() {
              _currentPortValue = value;
              widget.setPort(value);
            }),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black26),
            ),
          ),
        ]),
        Column(children: [
          SizedBox(height: 16),
          Text('Module',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.orangeAccent, fontSize: 18)),
          NumberPicker(
            value: _currentModuleValue,
            minValue: 1,
            maxValue: 10,
            step: 1,
            itemHeight: 80,
            itemWidth: 65,
            infiniteLoop: true,
            selectedTextStyle: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).accentColor, fontSize: 25),
            textStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 21),
            onChanged: (value) => setState(() {
              _currentModuleValue = value;
              widget.setModule(value);
            }),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black26),
            ),
          ),
        ])
      ],
    );
  }
}
