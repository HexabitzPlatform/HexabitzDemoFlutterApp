class RecentColor {
  final int id;
  final int color;
  RecentColor({this.id, this.color});
  Map<String, dynamic> toMap() {
    return {'color': this.color};
  }

  factory RecentColor.fromMap(int id, Map<String, dynamic> map) {
    return RecentColor(id: id, color: map['color']);
  }
  RecentColor copyWith({int id, int color}) {
    return RecentColor(id: id ?? this.id, color: color ?? this.color);
  }
}
