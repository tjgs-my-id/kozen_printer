import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:kozen_printer/kozen_printer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _kozenPrinterPlugin = KozenPrinter();
  bool _needScroll = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  String log = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void logMessage(String message) {
    setState(() {
      log += '$message\n';
      _needScroll = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _kozenPrinterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  _scrollToEnd() async {
    if (_needScroll) {
      _needScroll = false;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: ListView(
          children: <Widget>[
            Center(child: Text('Running on: $_platformVersion\n')),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _kozenPrinterPlugin.open();
                        logMessage('Printer opened successfully.');
                      } catch (e) {
                        logMessage('Error opening printer: $e');
                      }
                    },
                    child: const Text('Open Printer'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _kozenPrinterPlugin.close();
                        logMessage('Print job closed.');
                      } catch (e) {
                        logMessage('Error closing print job: $e');
                      }
                    },
                    child: const Text('Close Printer'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final status = await _kozenPrinterPlugin.status();
                        logMessage('Printer status: $status');
                      } catch (e) {
                        logMessage('Error checking printer status: $e');
                      }
                    },
                    child: const Text('Get Status'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _kozenPrinterPlugin.cleanCache();
                        logMessage('Printer cache cleaned.');
                      } catch (e) {
                        logMessage('Error cleaning printer cache: $e');
                      }
                    },
                    child: const Text('Clean Cache'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _kozenPrinterPlugin.beginPrint();
                        logMessage('Begin print command sent.');
                      } catch (e) {
                        logMessage('Error beginning print: $e');
                      }
                    },
                    child: const Text('Begin Print'),
                  ),
                  Divider(),
                  // Set Print Font with TextField
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: TextEditingController(
                            text: 'assets/fonts/Roboto-Regular.ttf',
                          ),
                          onChanged: (value) {
                            // Optionally store value in a variable if needed
                          },
                          decoration: const InputDecoration(
                            labelText: 'Font Path',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                          onSubmitted: (value) async {
                            try {
                              await _kozenPrinterPlugin.setPrintFont(value);
                              logMessage('Print font set to $value.');
                            } catch (e) {
                              logMessage('Error setting print font: $e');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          String fontPath = 'assets/fonts/Roboto-Regular.ttf';
                          try {
                            await _kozenPrinterPlugin.setPrintFont(fontPath);
                            logMessage('Print font set to $fontPath.');
                          } catch (e) {
                            logMessage('Error setting print font: $e');
                          }
                        },
                        child: const Text('Set Print Font'),
                      ),
                    ],
                  ),
                  // Set Print Gray with TextField
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: '128'),
                          decoration: const InputDecoration(
                            labelText: 'Gray',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                          onSubmitted: (value) async {
                            int? gray = int.tryParse(value);
                            if (gray == null) {
                              logMessage('Invalid gray value.');
                              return;
                            }
                            try {
                              await _kozenPrinterPlugin.setPrintGray(gray);
                              logMessage('Print gray set to $gray.');
                            } catch (e) {
                              logMessage('Error setting print gray: $e');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          int gray = 128;
                          try {
                            await _kozenPrinterPlugin.setPrintGray(gray);
                            logMessage('Print gray set to $gray.');
                          } catch (e) {
                            logMessage('Error setting print gray: $e');
                          }
                        },
                        child: const Text('Set Print Gray'),
                      ),
                    ],
                  ),
                  // Set Line Space with TextField
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: '5'),
                          decoration: const InputDecoration(
                            labelText: 'Line Space',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                          onSubmitted: (value) async {
                            int? space = int.tryParse(value);
                            if (space == null) {
                              logMessage('Invalid line space value.');
                              return;
                            }
                            try {
                              await _kozenPrinterPlugin.setLineSpace(space);
                              logMessage('Line space set to $space.');
                            } catch (e) {
                              logMessage('Error setting line space: $e');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          int space = 5;
                          try {
                            await _kozenPrinterPlugin.setLineSpace(space);
                            logMessage('Line space set to $space.');
                          } catch (e) {
                            logMessage('Error setting line space: $e');
                          }
                        },
                        child: const Text('Set Line Space'),
                      ),
                    ],
                  ),
                  // Line Wrap with TextField
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 80,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: '3'),
                          decoration: const InputDecoration(
                            labelText: 'Wrap',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                          onSubmitted: (value) async {
                            int? wrap = int.tryParse(value);
                            if (wrap == null) {
                              logMessage('Invalid wrap value.');
                              return;
                            }
                            try {
                              await _kozenPrinterPlugin.lineWrap(wrap);
                              logMessage('Line wrap set to $wrap.');
                            } catch (e) {
                              logMessage('Error setting line wrap: $e');
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          int wrap = 3;
                          try {
                            await _kozenPrinterPlugin.lineWrap(wrap);
                            logMessage('Line wrap set to $wrap.');
                          } catch (e) {
                            logMessage('Error setting line wrap: $e');
                          }
                        },
                        child: const Text('Line Wrap'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final length =
                            await _kozenPrinterPlugin.beforePrinterLength();
                        logMessage('Before Printer Length: $length');
                      } catch (e) {
                        logMessage('Error getting before printer length: $e');
                      }
                    },
                    child: const Text('Before Printer Length'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        final length =
                            await _kozenPrinterPlugin.printerLength();
                        logMessage('Printer Length: $length');
                      } catch (e) {
                        logMessage('Error getting printer length: $e');
                      }
                    },
                    child: const Text('Printer Length'),
                  ),
                  Divider(),
                  ElevatedButton(
                    onPressed: () async {
                      await _kozenPrinterPlugin.open();
                      await _kozenPrinterPlugin.addPrintLine(
                        'Hello, Kozen Printer!',
                        bold: true,
                        italic: false,
                      );
                      await _kozenPrinterPlugin.addPrintLine(
                        'Second line, small, italic.',
                        bold: false,
                        italic: true,
                      );
                      await _kozenPrinterPlugin.addPrintLine(
                        'Third line, medium, bold & italic.',
                        bold: true,
                        italic: true,
                      );
                      await _kozenPrinterPlugin.addPrintLine(
                        'Fourth line, large, normal.',
                        bold: false,
                        italic: false,
                      );
                      await _kozenPrinterPlugin.addPrintLine("");
                      await _kozenPrinterPlugin.addPrintLine("");
                      await _kozenPrinterPlugin.addPrintLine("");
                      await _kozenPrinterPlugin.beginPrint();
                      await _kozenPrinterPlugin.close();
                      logMessage('Print line added successfully.');
                    },
                    child: const Text('Test Print'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _kozenPrinterPlugin.open();
                        await _kozenPrinterPlugin.addPrintBase64(
                          'iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAMAAADDpiTIAAADAFBMVEUAAAAAAAAAAAAAAAA/Pz8zMzMqKiokJCQfHx8cHBwzMzMuLi4qKionJyckJCQiIiIvLy8tLS0qKiooKCgmJiYkJCQsLCwiIiIqKiooKCgnJyclJSUrKyskJCQqKiopKSknJycmJiYlJSUkJCQqKiopKSkoKCgnJycmJiYlJSUqKiopKSkoKCgnJycmJiYlJSUqKiopKSkoKCgoKCgnJycmJiYpKSklJSUoKCgoKCgnJycmJiYpKSkmJiYpKSkoKCgnJycnJycpKSkmJiYpKSkoKCgoKCgnJycmJiYmJiYpKSkoKCgoKCgnJycnJycmJiYpKSkoKCgoKCgnJycnJycnJycpKSkmJiYoKCgoKCgnJycnJycpKSkmJiYoKCgoKCgnJycnJycpKSknJycoKCgoKCgoKCgnJycnJycmJiYoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycpKSkoKCgoKCgoKCgnJycnJycoKCgnJycoKCgoKCgnJycnJycoKCgnJycoKCgoKCgnJycnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgoKCgnJycnJycoKCgnJycoKCgoKCgnJycnJycoKCgnJycoKCgoKCgnJycnJycoKCgnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgnJycoKCgoKCgnJycnJycoKCgnJycoKCgoKCgnJycnJycoKCgnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgoKCgnJycnJycoKCgnJycoKCgoKCgnJycnJycoKCgnJycoKCgoKCgnJycnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgnJycnJycnJycoKCgoKCgoKCgoKCiPra41AAAA/3RSTlMAAQIDBAUGBwgJCgsMDQ4PEBESExQVFxYYGRobHRweHyAhIiMkJSYnKCkqKywtLi8wMTIzNDU3Njg5Ojs9PD4/QEFDQkRFRkdISUpLTE1O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',
                          position: PrintLineAlign.center,
                        );
                        await _kozenPrinterPlugin.beginPrint();
                        await _kozenPrinterPlugin.close();
                        logMessage('Print base64 added successfully.');
                      } catch (e) {
                        logMessage('Error adding print base64: $e');
                      }
                    },
                    child: const Text('Test Print Image Base64'),
                  ),
                  Divider(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                // Text input
                                Expanded(
                                  child: SizedBox(
                                    height: 40,
                                    child: TextField(
                                      controller: _textController,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter text',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Print button
                                ElevatedButton(
                                  onPressed: () async {
                                    String userText =
                                        _textController.text.trim();
                                    if (userText.isEmpty) {
                                      logMessage('Please enter text to print.');
                                      return;
                                    }
                                    await _kozenPrinterPlugin.open();
                                    await _kozenPrinterPlugin.addPrintLine(
                                      userText,
                                    );
                                    await _kozenPrinterPlugin.beginPrint();
                                    await _kozenPrinterPlugin.close();
                                    logMessage('User text printed: $userText');
                                  },
                                  child: const Text('Print'),
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            SizedBox(
              height: 300,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Center(
                  child: Text(
                    'Log:\n$log',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
