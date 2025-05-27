# Kozen Printer Flutter Plugin

A Flutter plugin for integrating with Kozen print devices.

## Features

- Print text and images on Kozen printers
- Supports all Kozen printer devices (tested on Kozen P10 / Advan Harvard C1)
- Based on [cordova-plugin-kozen-p8-printer](https://github.com/SistePar/cordova-plugin-kozen-p8-printer) (thanks to them!)

## Getting Started

Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  kozen_printer: ^<latest_version>
```

Import and use in your Dart code:

```dart
import 'package:kozen_printer/kozen_printer.dart';

// Example usage
await _kozenPrinterPlugin.open();
await _kozenPrinterPlugin.addPrintLine("TEST PRINT");
await _kozenPrinterPlugin.addPrintLine("");
await _kozenPrinterPlugin.beginPrint();
await _kozenPrinterPlugin.close();
```

## Supported Devices

- All Kozen printer devices  
  _(Tested on Kozen P10 / Advan Harvard C1)_  
  [Product Info](https://advandigital.com/landing-page-product/harvard-c1/)

## Notes

> There is no official documentation available for Kozen printer devices.  
> Communication with the printer is done using the `com.pos.sdk.printer` package.

## Credits

- Kozen SDK and much of the code are adapted from [cordova-plugin-kozen-p8-printer](https://github.com/SistePar/cordova-plugin-kozen-p8-printer).

## License

See [LICENSE](LICENSE) for details.
