import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kozen_printer_method_channel.dart';

abstract class KozenPrinterPlatform extends PlatformInterface {
  /// Constructs a KozenPrinterPlatform.
  KozenPrinterPlatform() : super(token: _token);

  static final Object _token = Object();

  static KozenPrinterPlatform _instance = MethodChannelKozenPrinter();

  /// The default instance of [KozenPrinterPlatform] to use.
  ///
  /// Defaults to [MethodChannelKozenPrinter].
  static KozenPrinterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KozenPrinterPlatform] when
  /// they register themselves.
  static set instance(KozenPrinterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  Future<bool?> open();

  Future<bool?> close();

  Future<int?> status();

  Future<double?> beforePrinterLength();

  Future<double?> printerLength();

  Future<void> lineWrap(int value);

  Future<void> setLineSpace(int value);

  Future<void> setPrintFont(String path);

  Future<void> setPrintGray(int gray);

  Future<void> addPrintLine(
    String content, {
    int? position,
    int? size,
    bool? bold,
    bool? italic,
    bool? invert,
  });

  Future<void> addPrintBase64(String encodedString, {int? position});

  Future<bool?> beginPrint();

  Future<bool?> printTest();

  Future<void> cleanCache();
}
