import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class CustomIntegerPicker extends StatefulWidget {
  final Function setSource;
  final Function setDestination;
  final int source;
  final int destination;
  CustomIntegerPicker(
      {this.source, this.setSource, this.destination, this.setDestination});
  @override
  __CustomIntegerPickerState createState() => __CustomIntegerPickerState();
}

class __CustomIntegerPickerState extends State<CustomIntegerPicker> {
  int _currentSourceValue;
  int _currentDestinationValue;

  @override
  void initState() {
    super.initState();
    _currentSourceValue = widget.source;
    _currentDestinationValue = widget.destination;
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
                  .copyWith(color: Colors.orangeAccent, fontSize: 22)),
          NumberPicker(
            value: _currentSourceValue,
            minValue: 1,
            maxValue: 9,
            step: 1,
            itemHeight: 80,
            infiniteLoop: true,
            selectedTextStyle: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).accentColor, fontSize: 27),
            textStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 23),
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
                  .copyWith(color: Colors.orangeAccent, fontSize: 22)),
          NumberPicker(
            value: _currentDestinationValue,
            minValue: 1,
            maxValue: 9,
            step: 1,
            itemHeight: 80,
            infiniteLoop: true,
            selectedTextStyle: Theme.of(context)
                .textTheme
                .headline5
                ?.copyWith(color: Theme.of(context).accentColor, fontSize: 27),
            textStyle:
                Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 23),
            onChanged: (value) => setState(() {
              _currentDestinationValue = value;
              widget.setDestination(value);
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
