import 'package:hexabitz_demo_app/models/recent_color.dart';

abstract class RecentColorRepository {
  Future<int> insertRecentColor(RecentColor recentColor);

  Future updateRecentColor(RecentColor recentColor);

  Future deleteRecentColor(int recentColorId);

  Future<List<RecentColor>> getAllRecentColors();
}
