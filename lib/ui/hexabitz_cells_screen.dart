import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hexabitz_demo_app/models/hexabitz_cells.dart';

import 'item/hexabitx_cells_item.dart';

class HexabitzCellsScreen extends StatelessWidget {
  const HexabitzCellsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    List<HexabitzCell> hexabitzCell = [
      HexabitzCell(
          id: "1",
          title: "H26R0 load cell",
          description: "It is a load cell sensor interface module",
          //"It is a load cell (strain gauge) sensor interface module based on Avia Semiconductor HX711 Wheatstone bridge ADC and STM32F0 MCU",
          image: "assets/images/module_h26r0_load_cell.png"),
      HexabitzCell(
          id: "2",
          title: "H08R6 IR sensor",
          description: "It is a time-of-flight (ToF) ranging sensor module",
          // "It is an infrared (IR) time-of-flight (ToF) ranging sensor module based on ST VL53L0X sensor and STM32F0 MCU",
          image: "assets/images/module_h08r6_ir_sensor.png"),
      HexabitzCell(
          id: "3",
          title: "H0FR60 relay AC",
          description: "It is a solid state relay (SSR) module",
          //"It is a compact solid state relay (SSR) module capable of driving AC loads up to 600V and 1.2A. It is based on Panasonic AQH3213A SSR and STM32F0 MCU",
          image: "assets/images/module_h09r00_relay.png"),
      HexabitzCell(
          id: "4",
          title: "H01R00 RGB led",
          description: "It is an RGB LED module",
          //"It is a smart RGB LED module based on Cree CLVBA-FKA-CC1F1L1BB7R3R3 RGB LED and STM32F0 MCU",
          image: "assets/images/module_h01r00_led.png"),
      HexabitzCell(
          id: "5",
          title: "H0BR40 IMU",
          description: "It is a 3-axis initial measurement unit (IMU)",
          // "It is a 3-axis initial measurement unit (IMU) combined with a 3-axis digital compass module based on STM32F0 MCU, LSM6DS3 IMU and LSM303AGR compass",
          image: "assets/images/module_h0br40_imu.png"),
      /*HexabitzCell(
          id: "6",
          title: "H01R00 RGB led",
          description:
              "It is a smart RGB LED module based on Cree CLVBA-FKA-CC1F1L1BB7R3R3 RGB LED and STM32F0 MCU",
          image: "assets/images/module_h01r00_led.png"),*/
    ];
    return AnimationLimiter(
      child: GridView(
        children: hexabitzCell
            .map((cellData) => AnimationConfiguration.staggeredGrid(
                  position: int.parse(cellData.id) - 1,
                  duration: const Duration(milliseconds: 1000),
                  columnCount: 2,
                  child: ScaleAnimation(
                    duration: const Duration(milliseconds: 500),
                    child: HexabitzCellItem(
                      id: cellData.id,
                      title: cellData.title,
                      description: cellData.description,
                      image: cellData.image,
                    ),
                  ),
                ))
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250,
          childAspectRatio: isLandscape ? 0.95 : 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 0,
        ),
      ),
    );
  }
}
