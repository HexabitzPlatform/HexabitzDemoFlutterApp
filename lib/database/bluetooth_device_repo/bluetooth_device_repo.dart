import 'package:hexabitz_demo_app/models/bluetooth_device_item.dart';

abstract class BluetoothDeviceRepo {
  Future<int> insertDevice(BluetoothDevice device);

  Future updateDevice(BluetoothDevice device);

  Future deleteDevice(int deviceId);

  Future<List<BluetoothDevice>> getAllCakes();
}
