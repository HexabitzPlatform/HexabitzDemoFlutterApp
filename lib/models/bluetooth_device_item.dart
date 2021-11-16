class BluetoothDevice {
  final int id;
  final String deviceId;
  String name;
  BluetoothDevice({this.id, this.deviceId, this.name});

  Map<String, dynamic> toMap() {
    return {'deviceId': this.deviceId, 'name': this.name};
  }

  factory BluetoothDevice.fromMap(int id, Map<String, dynamic> map) {
    return BluetoothDevice(
      id: id,
      deviceId: map['deviceId'],
      name: map['name'],
    );
  }

  BluetoothDevice copyWith({int id, String name, int yummyness}) {
    return BluetoothDevice(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
    );
  }
}
