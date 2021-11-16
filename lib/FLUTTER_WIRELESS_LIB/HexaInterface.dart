class HexaInterface {
  // Enum for the codes to be sent to the modules
  //region Message_Codes
  // Bos Messages
  static const int CODE_PING = 1;
  static const int CODE_IND_ON = 3;

  // H01R0 (Led Module)
  static const int CODE_H01R0_ON = 100;
  static const int CODE_H01R0_OFF = 101;
  static const int CODE_H01R0_TOGGLE = 102;
  static const int CODE_H01R0_COLOR = 103;
  static const int CODE_H01R0_PULSE = 104;
  static const int CODE_H01R0_SWEEP = 105;
  static const int CODE_H01R0_DIM = 106;

  // H08R6x (IR Sensor)
  static const int CODE_H08R6_GET_INFO = 400;
  static const int CODE_H08R6_SAMPLE = 401;
  static const int CODE_H08R6_STREAM_PORT = 402;
  static const int CODE_H08R6_STREAM_MEM = 403;
  static const int CODE_H08R6_RESULT_MEASUREMENT = 404;
  static const int CODE_H08R6_STOP_RANGING = 405;
  static const int CODE_H08R6_SET_UNIT = 406;
  static const int CODE_H08R6_GET_UNIT = 407;
  static const int CODE_H08R6_RESPOND_GET_UNIT = 408;
  static const int CODE_H08R6_MAX_RANGE = 409;
  static const int CODE_H08R6_MIN_RANGE = 410;
  static const int CODE_H08R6_TIMEOUT = 411;

  // H0FR6x (Relay)
  static const int CODE_H0FR6_ON = 750;
  static const int CODE_H0FR6_OFF = 751;
  static const int CODE_H0FR6_TOGGLE = 752;
  static const int CODE_H0FR6_PWM = 753;

  // H26R0x (Load-Cell Module)
  static const int CODE_H26R0_STREAM_PORT_GRAM = 1901;
  static const int CODE_H26R0_STREAM_PORT_KGRAM = 1902;
  static const int CODE_H26R0_STREAM_PORT_OUNCE = 1903;
  static const int CODE_H26R0_STREAM_PORT_POUND = 1904;
  static const int CODE_H26R0_STOP = 1905;
  static const int CODE_H26R0_ZEROCAL = 1910;

  // H0BR4x (IMU Module)
  static const int CODE_H0BR4_GET_GYRO = 550;
  static const int CODE_H0BR4_GET_ACC = 551;
  static const int CODE_H0BR4_GET_MAG = 552;
  static const int CODE_H0BR4_GET_TEMP = 553;
  static const int CODE_H0BR4_RESULT_GYRO = 554;
  static const int CODE_H0BR4_RESULT_ACC = 555;
  static const int CODE_H0BR4_RESULT_MAG = 556;
  static const int CODE_H0BR4_RESULT_TEMP = 557;
  static const int CODE_H0BR4_STREAM_GYRO = 558;
  static const int CODE_H0BR4_STREAM_ACC = 559;
  static const int CODE_H0BR4_STREAM_MAG = 560;
  static const int CODE_H0BR4_STREAM_TEMP = 561;
  static const int CODE_H0BR4_STREAM_STOP = 562;

  // endregion

  //region Options_Byte

  // 8th bit (MSB): Long messages flag. If set; then message parameters continue in the next message.
  //Options8_Next_Message
  static const int Options8_Next_Message_FALSE = 0;
  static const int Options8_Next_Message_TRUE = 1;

  // 6-7th bits:
  //Options67_Response_Options
  static const int Options67_Response_Options_SEND_BACK_NO_RESPONSE = 00;
  static const int Options67_Response_Options_SEND_RESPONSES_ONLY_MESSAGES = 01;
  static const int
      Options67_Response_Options_SEND_RESPONSES_ONLY_TO_CLI_COMMANDS = 10;
  static const int Options67_Response_Options_SEND_RESPONSES_TO_EVERYTHING = 11;

  // 5th bit: reserved.
  //Options5_Reserved
  static const int Options5_Reserved_FALSE = 0;
  static const int Options5_Reserved_TRUE = 1;

  // 3rd-4th bits:
  //Options34_Trace_Options
  static const int Options34_Trace_Options_SHOW_NO_TRACE = 00;
  static const int Options34_Trace_Options_SHOW_MESSAGE_TRACE = 01;
  static const int Options34_Trace_Options_SHOW_MESSAGE_RESPONSE_TRACE = 10;
  static const int
      Options34_Trace_Options_SHOW_TRACE_FOR_BOTH_MESSAGES_AND_THEIR_RESPONSES =
      11;

  // 2nd bit: Extended Message Code flag. If set; then message codes are 16 bits.
  //Options2_16_BIT_Code
  static const int Options2_16_BIT_Code_FALSE = 0;
  static const int Options2_16_BIT_Code_TRUE = 1;

  // 1st bit (LSB): Extended Options flag. If set; then the next byte is an Options byte as well.
  //Options1_Extended_Flag
  static const int Options1_Extended_Flag_FALSE = 0;
  static const int Options1_Extended_Flag_TRUE = 1;

// endregion

}
