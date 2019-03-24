
import 'package:narai/interpreter/qr.dart';

enum ResultType {
  INFO,
  GOOD,
  SUCCESS,
  BAD,
  FAIL
}

class Result {
  final String color;
  final String textImage;
  final String text;
  final String titleImage;
  final String title;
  final ResultType type;
  final QRLine qrLine;

  Result({ this.type = ResultType.INFO, this.color = "blue", this.text, this.titleImage, this.title, this.textImage, this.qrLine }); 
}