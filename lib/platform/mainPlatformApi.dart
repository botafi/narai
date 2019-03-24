import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:narai/interpreter/qr.dart';

class MainPlatformApi implements QRApi {
  final platform = MethodChannel('app/main', const JSONMethodCodec());
  Future<Iterable<QR>> getQRs() async {
    List<dynamic> res = json.decode(await platform.invokeMethod("capture"));
    if(res != null) {
      return res.map((qr) => QR.fromJSON(qr));
    } else {
      return [];
    }
  }
}

MainPlatformApi mainPlatformApi = MainPlatformApi();