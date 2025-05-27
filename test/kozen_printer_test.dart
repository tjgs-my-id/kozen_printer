import 'package:flutter_test/flutter_test.dart';
import 'package:kozen_printer/kozen_printer.dart';
import 'package:kozen_printer/kozen_printer_platform_interface.dart';
import 'package:kozen_printer/kozen_printer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKozenPrinterPlatform
    with MockPlatformInterfaceMixin
    implements KozenPrinterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool?> open() => Future.value(true);

  @override
  Future<bool?> close() => Future.value(true);

  @override
  Future<int?> status() => Future.value(1);

  @override
  Future<void> addPrintLine(
    String content, {
    int? position,
    int? size = 24,
    bool? bold,
    bool? italic,
    bool? invert,
  }) async {}

  @override
  Future<void> addPrintBase64(String base64Image, {int? position}) async {}

  @override
  Future<void> cleanCache() async {}

  @override
  Future<bool?> beginPrint() => Future.value(true);

  @override
  Future<bool?> printTest() => Future.value(true);

  @override
  Future<double?> printerLength() => Future.value(0.0);

  @override
  Future<double?> beforePrinterLength() => Future.value(0.0);

  @override
  Future<void> lineWrap(int lines) async {}

  @override
  Future<void> setLineSpace(int space) async {}

  @override
  Future<void> setPrintFont(String path) {
    throw UnimplementedError('setPrintFont is not implemented');
  }

  @override
  Future<void> setPrintGray(int gray) {
    throw UnimplementedError('setPrintGray is not implemented');
  }
}

void main() {
  final KozenPrinterPlatform initialPlatform = KozenPrinterPlatform.instance;

  test('$MethodChannelKozenPrinter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKozenPrinter>());
  });

  group('KozenPrinter', () {
    late KozenPrinter kozenPrinter;
    late MockKozenPrinterPlatform fakePlatform;

    setUp(() {
      kozenPrinter = KozenPrinter();
      fakePlatform = MockKozenPrinterPlatform();
      KozenPrinterPlatform.instance = fakePlatform;
    });

    test('getPlatformVersion', () async {
      expect(await kozenPrinter.getPlatformVersion(), '42');
    });

    test('open', () async {
      expect(await kozenPrinter.open(), true);
    });

    test('status', () async {
      expect(await kozenPrinter.status(), 1);
    });

    test('addPrintLine', () async {
      await kozenPrinter.addPrintLine(
        'test',
        size: 2,
        position: PrintLineAlign.center,
        bold: true,
        italic: true,
        invert: true,
      );
    });

    test('addPrintBase64', () async {
      await kozenPrinter.addPrintBase64(
        'base64string',
        position: PrintLineAlign.center,
      );
    });

    test('cleanCache', () async {
      await kozenPrinter.cleanCache();
    });

    test('beginPrint', () async {
      expect(await kozenPrinter.beginPrint(), true);
    });

    test('status', () async {
      expect(await kozenPrinter.status(), 1);
    });

    test('close', () async {
      expect(await kozenPrinter.close(), true);
    });

    test('status', () async {
      expect(await kozenPrinter.status(), 1);
    });

    test('printTest', () async {
      expect(await kozenPrinter.printTest(), true);
    });
  });
}
