import 'package:get_it/get_it.dart';
import 'package:hexabitz_demo_app/models/bluetooth_device_item.dart';

import 'package:sembast/sembast.dart';

import 'bluetooth_device_repo.dart';

class SembastBluetoothDeviceRepo extends BluetoothDeviceRepo {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store("bluetooth_device");

  @override
  Future<int> insertDevice(BluetoothDevice device) async {
    return await _store.add(_database, device.toMap());
  }

  @override
  Future updateDevice(BluetoothDevice device) async {
    await _store.record(device.id).update(_database, device.toMap());
  }

  @override
  Future deleteDevice(int deviceId) async {
    await _store.record(deviceId).delete(_database);
  }

  @override
  Future<List<BluetoothDevice>> getAllCakes() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map(
            (snapshot) => BluetoothDevice.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }
}
