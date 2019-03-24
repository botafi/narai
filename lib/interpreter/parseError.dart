import 'package:narai/interpreter/qr.dart';

class ParseInterpretError implements Exception {
  Object message;
  Object stackTrace;
  QRLine qrLine;
  ParseInterpretError({ this.message, this.stackTrace, this.qrLine }) {
    if(this.qrLine != null) {
      this.qrLine.error = this;
    }
  }
  @override
  String toString() {
    return "ParseInterpretError \n message: $message \n stackTrace: $stackTrace";
  }
}