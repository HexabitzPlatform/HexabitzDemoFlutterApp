import 'package:get_it/get_it.dart';
import 'package:hexabitz_demo_app/database/recent_color_repository.dart';
import 'package:hexabitz_demo_app/database/sembast_recentColor_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'bluetooth_device_repo/bluetooth_device_repo.dart';
import 'bluetooth_device_repo/sembast_bluetooth_device_repo.dart';

class Init {
  static Future initialize() async {
    await _initSembast();
    _registerRepositories();
  }

  static Future _initSembast() async {
    final appDir = await getApplicationDocumentsDirectory();
    await appDir.create(recursive: true);
    final databasePath = join(appDir.path, "sembast.db");
    final database = await databaseFactoryIo.openDatabase(databasePath);
    GetIt.I.registerSingleton<Database>(database);
  }

  static _registerRepositories() {
    GetIt.I.registerLazySingleton<RecentColorRepository>(
        () => SembastRecentColorRepository());
    //for BluetoothDevices
    if (!GetIt.I.isRegistered<BluetoothDeviceRepo>()) {
      GetIt.I.registerLazySingleton<BluetoothDeviceRepo>(
          () => SembastBluetoothDeviceRepo());
    }
  }
}
