import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexabitz_demo_app/ui/hexabitz_modules/h01r00_rgb_led.dart';
import 'package:hexabitz_demo_app/ui/hexabitz_modules/h08r6_ir_sensor.dart';
import 'package:hexabitz_demo_app/ui/hexabitz_modules/h0br40_imu.dart';
import 'package:hexabitz_demo_app/ui/hexabitz_modules/h0fr60_relay_ac.dart';
import 'package:hexabitz_demo_app/ui/hexabitz_modules/h26r0_load_cell.dart';

class HexabitzCellItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String image;
  const HexabitzCellItem(
      {Key key, this.id, this.title, this.description, this.image})
      : super(key: key);
  void selectCell(BuildContext context) {
    if (id == "1") {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return SlideInUp(
            duration: const Duration(milliseconds: 200), child: WeightModule());
      }));
    }
    if (id == "2") {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return SlideInUp(
            duration: const Duration(milliseconds: 200), child: IRSensor());
      }));
    }
    if (id == "3") {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return SlideInUp(
            duration: const Duration(milliseconds: 200),
            child: RelayACModules());
      }));
    }
    if (id == "4") {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return SlideInUp(
            duration: const Duration(milliseconds: 200), child: RGBLedModule());
      }));
    }
    if (id == "5") {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return SlideInUp(
            duration: const Duration(milliseconds: 200), child: IMUModule());
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
      padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4,
        child: InkWell(
          onTap: () => selectCell(context),
          borderRadius: BorderRadius.circular(15.0),
          child: Column(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      alignment: Alignment.center,
                      image: AssetImage(image),
                    )),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                        Colors.black.withOpacity(.2),
                        Colors.black.withOpacity(.1),
                      ])),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      color: Colors.black.withOpacity(.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.aladin(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: GoogleFonts.archivo(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
