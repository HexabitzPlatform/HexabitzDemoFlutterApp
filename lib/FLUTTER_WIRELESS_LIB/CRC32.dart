import 'dart:typed_data';

class CRC32 {
  int reversInt(int b) {
    int r = 0, m = 1, bit;
    for (int i = 0; i < 32; i++) {
      bit = ((b & m) & 0xFFFFFFFF) >> i;
      // print("bit = ${bit}");
      r = r | (bit << (31 - i));
      // print("r = ${r}");
      m = m << 1;
      //print("m = ${m}");
    }
    return r;
  }

  int reverseByte(int b) {
    int r = 0, m = 1, bit;
    print("b = ${b}");
    for (int i = 0; i < 8; i++) {
      bit = (b & m) >> i;
      r = r | (bit << (7 - i));
      m = m << 1;
    }
    print("res = ${(r & 0xff)}");
    return (r & 0xff);
  }

  int calc2(Uint32List ba, int offset, int count) {
    /*   int crc = 0xFFFFFFFF; // initial contents of LFBSR
    int poly = 0xEDB88320; // polynomial
    int temp;
    for (int j = offset; j < count + offset; j++) {
      temp = (crc ^ reverseByte(ba[j])) & 0xff;
      for (int i = 0; i < 8; i++) // read 8 bits one at a time
      {
        if ((temp & 1) == 1)
          temp = (temp >> 1) ^ poly;
        else
          temp = (temp >> 1);
      }
      crc = (crc >> 8) ^ temp;
    }
    print(("res = ${crc}"));
    print(("crc = ${reversInt(crc)}"));
    return reversInt(crc);*/
    int CRC = 0xFFFFFFFF, MSB;
    for (int i = 0; i < ba.length; i++) {
      CRC ^= (ba[i] << 24);
      for (int j = 0; j < 8; j++) {
        MSB = CRC >> 31;
        CRC <<= 1;
        CRC ^= (0 - MSB) & 0x04C11DB7;
      }
    }
    print(CRC);
    return 0;
  }
}
//0x2 0x10 0x5A 0x48 0x7 0x6D 0x22 0x1 0x1 0x0 0x0 0x1 0x-3D 0x0 0x0 0x-c 0x0 0x1 0x6 0x50
