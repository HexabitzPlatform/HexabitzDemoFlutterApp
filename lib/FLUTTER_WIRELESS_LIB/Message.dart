import 'dart:typed_data';

import 'package:crclib/catalog.dart';

class Message {
  //region Variables
  int H = 0x48,
      Z = 0x5A,
      length = 0,
      destination,
      source,
      options,
      // ignore: non_constant_identifier_names
      LSC, // Least significance code byte.
      // ignore: non_constant_identifier_names
      MSC, // Most significance code byte.
      // Message byte array
      // ...
      // ignore: non_constant_identifier_names
      CRC;
  List<int> allMessageList = [];
  List<int> payload = [], allMessage = [];
//endregion
  /// <summary>
  /// The Hexabitz Buffer class wiki: https://hexabitz.com/docs/code-overview/array-messaging/
  /// The general constructor, all the payload parameters [Par1, Par2,...] must be included in the correct order within the Message array.
  /// </summary>
  Message(this.destination, this.source, this.options, int code, this.payload) {
    LSC = code & 0xFF;
    MSC = code >> 8;
    allMessageList.add(H);
    allMessageList.add(Z);
    allMessageList.add(length);
    allMessageList.add(destination);
    allMessageList.add(source);
    allMessageList.add(options);
    allMessageList.add(LSC);
    if (MSC != 0) // If the code is only one byte so the MSC
    {
      allMessageList.add(MSC);
      print("Xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
    }
    allMessageList.addAll(payload);
    length = allMessageList.length -
        3; // Not including H & Z delimiters, the length byte itself and the CRC byte
    // so its 4 but we didn't add the CRC yet so its 3.
    allMessageList[2] = length; // Replace it with the correct length value.
    print("payload:${payload}");
    print("code:$code");
    print(allMessageList);
    print(reverse(allMessageList));
    print(Crc32Mpeg2().convert(reverse(allMessageList)));
    CRC = int.parse(Crc32Mpeg2().convert(reverse(allMessageList)).toString());
    allMessageList.add(CRC);
    allMessage.addAll(allMessageList);
  }
  Uint8List getMessage() {
    print(allMessageList);
    //here we get CRC in the first 2 Byte because it cast in Uint8List
    print("Uint8List=${Uint8List.fromList(allMessage)}");
    return Uint8List.fromList(allMessage);
  }

  List<int> reverse(List<int> data) {
    //print(Crc32Mpeg2().convert(reverse(test)));
    List<int> data2 = [];
    data2.addAll(data);
    List<int> result = [], temp = [];
    while (data2.isNotEmpty) {
      if (data2.length > 4) {
        for (int i = 0; i < 4; i++) {
          temp.add(data2[i]);
        }
        data2.removeRange(0, 4);
      } else {
        for (int i = 0; i < 4; i++) {
          if (i < data2.length) {
            temp.add(data2[i]);
          } else
            temp.add(0);
        }
        data2.removeRange(0, data2.length);
      }
      result.addAll(temp.reversed);
      temp.clear();
    }
    return result;
  }
}
