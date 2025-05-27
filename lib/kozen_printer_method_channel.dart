import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kozen_printer_platform_interface.dart';

/// An implementation of [KozenPrinterPlatform] that uses method channels.
class MethodChannelKozenPrinter extends KozenPrinterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kozen_printer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool?> open() async {
    return await methodChannel.invokeMethod<bool>('open');
  }

  @override
  Future<bool?> close() {
    return methodChannel.invokeMethod<bool>('close');
  }

  @override
  Future<int?> status() {
    return methodChannel.invokeMethod<int>('status');
  }

  @override
  Future<double?> beforePrinterLength() {
    return methodChannel.invokeMethod<double>('beforePrinterLength');
  }

  @override
  Future<double?> printerLength() {
    return methodChannel.invokeMethod<double>('printerLength');
  }

  @override
  Future<void> lineWrap(int value) {
    return methodChannel.invokeMethod<void>('lineWrap', {'value': value});
  }

  @override
  Future<void> setLineSpace(int line) {
    return methodChannel.invokeMethod<void>('setLineSpace', {'line': line});
  }

  @override
  Future<void> setPrintFont(String path) {
    return methodChannel.invokeMethod<void>('setPrintFont', {'path': path});
  }

  @override
  Future<void> setPrintGray(int gray) {
    return methodChannel.invokeMethod<void>('setPrintGray', {'gray': gray});
  }

  @override
  Future<void> addPrintLine(
    String content, {
    int? position,
    int? size,
    bool? bold,
    bool? italic,
    bool? invert,
  }) async {
    return await methodChannel.invokeMethod<void>('addPrintLine', {
      'content': content,
      'position': position,
      'size': size,
      'bold': bold,
      'italic': italic,
      'invert': invert,
    });
  }

  @override
  Future<void> addPrintBase64(String encodedString, {int? position}) {
    return methodChannel.invokeMethod<void>('addPrintBase64', {
      'encodedString': encodedString,
      'position': position,
    });
  }

  @override
  Future<void> cleanCache() {
    return methodChannel.invokeMethod<bool>('cleanCache');
  }

  @override
  Future<bool?> beginPrint() {
    return methodChannel.invokeMethod<bool>('beginPrint');
  }

  @override
  Future<bool?> printTest() {
    return methodChannel.invokeMethod<bool>('printTest');
  }
}
