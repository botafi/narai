import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class NaraiLicenseEntry extends LicenseEntry {
  final List<String> _packages;

  final List<LicenseParagraph> _paragraphs;

  const NaraiLicenseEntry(this._packages, this._paragraphs);

  @override
  Iterable<String> get packages => this._packages;

  @override
  Iterable<LicenseParagraph> get paragraphs => this._paragraphs;

}

Stream<LicenseEntry> loadLicenses() async* {
  yield NaraiLicenseEntry(["Gson"], [LicenseParagraph(await rootBundle.loadString("assets/license/Gson"), 1)]);
  yield NaraiLicenseEntry(["Firebase ML Kit"], [LicenseParagraph(await rootBundle.loadString("assets/license/MLKit"), 1)]);
  yield NaraiLicenseEntry(["Zxing"], [LicenseParagraph(await rootBundle.loadString("assets/license/Zxing"), 1)]);
}