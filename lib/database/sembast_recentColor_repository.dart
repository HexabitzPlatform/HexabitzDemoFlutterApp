import 'package:get_it/get_it.dart';
import 'package:hexabitz_demo_app/models/recent_color.dart';
import 'package:sembast/sembast.dart';

import 'recent_color_repository.dart';

class SembastRecentColorRepository extends RecentColorRepository {
  final Database _database = GetIt.I.get();
  final StoreRef _store = intMapStoreFactory.store("recentColor_store");

  @override
  Future<int> insertRecentColor(RecentColor recentColor) async {
    return await _store.add(_database, recentColor.toMap());
  }

  @override
  Future updateRecentColor(RecentColor recentColor) async {
    await _store.record(recentColor.id).update(_database, recentColor.toMap());
  }

  @override
  Future deleteRecentColor(int recentColorId) async {
    await _store.record(recentColorId).delete(_database);
  }

  @override
  Future<List<RecentColor>> getAllRecentColors() async {
    final snapshots = await _store.find(_database);
    return snapshots
        .map((snapshot) => RecentColor.fromMap(snapshot.key, snapshot.value))
        .toList(growable: false);
  }
}
