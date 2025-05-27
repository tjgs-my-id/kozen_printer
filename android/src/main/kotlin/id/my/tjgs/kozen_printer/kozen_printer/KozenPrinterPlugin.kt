package id.my.tjgs.kozen_printer.kozen_printer

import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import com.pos.sdk.printer.POIPrinterManager
import com.pos.sdk.printer.POIPrinterManager.IPrinterListener
import com.pos.sdk.printer.models.BitmapPrintLine
import com.pos.sdk.printer.models.PrintLine
import com.pos.sdk.printer.models.TextPrintLine
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Base64


/** KozenPrinterPlugin */
class KozenPrinterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  companion object {
    private const val TAG: String = "KozenPrinter"
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var printerManager: POIPrinterManager? = null;
  //private lateinit var activity: Activity

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "kozen_printer")
    channel.setMethodCallHandler(this)

    context = flutterPluginBinding.applicationContext;
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${Build.VERSION.RELEASE}");
      
    } else if (call.method == "open") {
      printerManager = POIPrinterManager(context);
      printerManager?.open();
      result.success(true);

    } else if (call.method == "close") {
      printerManager?.close();
      //printerManager = null;
      result.success(true);

    } else if (call.method == "status") {
      if (checkBeforePrint(call, result)) {
        result.success(printerManager?.printerState);
      }

    } else if (call.method == "beforePrinterLength") {
      if (checkBeforePrint(call, result)) {
        result.success(printerManager?.beforePrinterLength);
      }

    } else if (call.method == "printerLength") {
      if (checkBeforePrint(call, result)) {
        result.success(printerManager?.printerLength);
      }

    } else if (call.method == "lineWrap") {
      if (checkBeforePrint(call, result)) {
        val value = call.argument<Int>("value");
        require(value != null)
        printerManager?.lineWrap(value)
        result.success(true);
      }
    }
    else if (call.method == "setLineSpace") {
      if (checkBeforePrint(call, result)) {
        val line = call.argument<Int>("line");
        require(line != null)
        printerManager?.setLineSpace(line);
        result.success(true);
      }
    }
    else if (call.method == "setPrintFont") {
      if (checkBeforePrint(call, result)) {
        val path = call.argument<String>("path");
        require(path != null)
        printerManager?.setPrintFont(path)
        result.success(true);
      }
    }
    else if (call.method == "setPrintGray") {
      if (checkBeforePrint(call, result)) {
        val gray = call.argument<Int>("gray");
        require(gray != null)
        printerManager?.setPrintGray(gray)
        result.success(true);
      }
    } else if (call.method == "addPrintLine") {
      if (checkBeforePrint(call, result)) {
        printerManager?.addPrintLine(
          TextPrintLine(
            call.argument<String>("content"),
            call.argument<Int>("position") ?: PrintLine.CENTER,
            call.argument<Int>("size") ?: TextPrintLine.FONT_NORMAL,
            call.argument<Boolean>("bold") == true,
            call.argument<Boolean>("italic") == true,
            call.argument<Boolean>("invert") == true,
          )
        )
        result.success(true)
      }

    } else if (call.method == "addPrintBase64") {
      if (checkBeforePrint(call, result)) {
        var encodedString = call.argument<String>("encodedString");
        var position = call.argument<Int>("position") ?: PrintLine.CENTER;

        require (encodedString != null, { "encodedString is null" });

        val pureBase64Encoded: String? = encodedString.substring(encodedString.indexOf(",") + 1)
        val decodedBytes: ByteArray =
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Base64.getDecoder().decode(pureBase64Encoded)
          } else {
            throw Error("Android version is not supported, only android 26 and up is supported");
          }
        val decodedBitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.size)

        printerManager?.addPrintLine(BitmapPrintLine(decodedBitmap, position))
        result.success(true);
      }

    }
    else if (call.method == "cleanCache") {
      if (checkBeforePrint(call, result)) {
        printerManager?.cleanCache();
        result.success(true);
      }
    }

    else if (call.method == "beginPrint") {
      if (checkBeforePrint(call, result)) {
        beginPrint(call, result)
      }

    } else if (call.method == "printTest") {
      if (checkBeforePrint(call, result)) {
        printerManager?.addPrintLine(TextPrintLine("HOLA SISTEPAR", PrintLine.CENTER));
        printerManager?.addPrintLine(TextPrintLine(""));
        printerManager?.addPrintLine(TextPrintLine(""));
        printerManager?.addPrintLine(TextPrintLine(""));
        //printerManager.setLineSpace(5);

        beginPrint(call, result)
      }

    } else {
      result.notImplemented()
    }
  }

  fun checkBeforePrint(call: MethodCall, result: Result): Boolean {
    if (printerManager == null) {
      result.error("printManager is null", "Open the printer first before print", null);
      return false;
    }
    return true;
  }

  fun beginPrint(call: MethodCall, result: Result) {
    var listener = object : IPrinterListener {
      override fun onStart() {
        Log.d(TAG, "beginPrint started");
      }
      override fun onFinish() {
        Log.d(TAG, "beginPrint finished");
        printerManager?.cleanCache();
        printerManager?.close();
        result.success(true);
      }

      override fun onError(code: Int, msg: String?) {
        Log.e(TAG, "ERROR CODE: " + code + "; MESSAGE: " + msg)
        printerManager?.close()
        result.error(code.toString(), msg, null);
      }
    }

    if(printerManager?.printerState == 4){
      printerManager?.close();
      return;
    }

    printerManager?.beginPrint(listener);
  }

  //region unused methods
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
  //endregion
}
