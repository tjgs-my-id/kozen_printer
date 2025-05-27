import 'package:kozen_printer/models/print_line.dart';

import 'kozen_printer_platform_interface.dart';

export './models/print_line.dart';

class KozenPrinter {
  Future<String?> getPlatformVersion() {
    return KozenPrinterPlatform.instance.getPlatformVersion();
  }

  Future<bool?> open() {
    return KozenPrinterPlatform.instance.open();
  }

  Future<bool?> close() {
    return KozenPrinterPlatform.instance.close();
  }

  Future<int?> status() {
    return KozenPrinterPlatform.instance.status();
  }

  Future<double?> beforePrinterLength() {
    return KozenPrinterPlatform.instance.beforePrinterLength();
  }

  Future<double?> printerLength() {
    return KozenPrinterPlatform.instance.printerLength();
  }

  Future<void> lineWrap(int value) {
    return KozenPrinterPlatform.instance.lineWrap(value);
  }

  Future<void> setLineSpace(int value) {
    return KozenPrinterPlatform.instance.setLineSpace(value);
  }

  Future<void> setPrintFont(String path) {
    return KozenPrinterPlatform.instance.setPrintFont(path);
  }

  Future<void> setPrintGray(int gray) {
    return KozenPrinterPlatform.instance.setPrintGray(gray);
  }

  Future<void> addPrintLine(
    String content, {
    PrintLineAlign? position,
    int? size = 24,
    bool? bold,
    bool? italic,
    bool? invert,
  }) {
    return KozenPrinterPlatform.instance.addPrintLine(
      content,
      position: position?.index,
      size: size,
      bold: bold,
      italic: italic,
      invert: invert,
    );
  }

  Future<void> addPrintBase64(
    String encodedString, {
    PrintLineAlign? position,
  }) {
    return KozenPrinterPlatform.instance.addPrintBase64(
      encodedString,
      position: position?.index,
    );
  }

  Future<void> cleanCache() {
    return KozenPrinterPlatform.instance.cleanCache();
  }

  Future<bool?> beginPrint() {
    return KozenPrinterPlatform.instance.beginPrint();
  }

  Future<bool?> printTest() {
    return KozenPrinterPlatform.instance.printTest();
  }
}
