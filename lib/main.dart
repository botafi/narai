import 'package:flutter/foundation.dart';
import 'package:narai/routing.dart';
import 'package:narai/widgets/app.dart';
import 'package:flutter/material.dart';
import 'package:narai/licenses.dart';


void main() {
  initRouter();
  LicenseRegistry.addLicense(loadLicenses);
  runApp(new App());
}
