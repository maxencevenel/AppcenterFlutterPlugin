package com.github.maxencevenel.appcenter_flutter_plugin

import android.app.Application
import android.util.Log
import androidx.annotation.NonNull
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AppcenterFlutterPlugin */
class AppcenterFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {


  companion object {
    const val methodChannelName = "appcenter_flutter_plugin"

    var application: Application? = null
  }

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, methodChannelName)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.d("onMethodCall", "[${methodChannelName}] ${call.method}")
    try {
      when (call.method) {
        "start" -> {
          if (application == null) {
            val error = "Fail to resolve Application on registration"
            Log.e(call.method, error)
            result.error(call.method, error, Exception(error))
            return
          }

          val appSecret = call.argument<String>("secret")

          if (appSecret == null || appSecret.isEmpty()) {
            val error = "App secret is not set"
            Log.e(call.method, error)
            result.error(call.method, error, Exception(error))
            return
          }

          AppCenter.start(application, appSecret, Analytics::class.java, Crashes::class.java)
        }
        "trackEvent" -> {
          val name = call.argument<String>("name")
          val properties = call.argument<Map<String, String>>("properties")
          Analytics.trackEvent(name, properties)
        }
        "getInstallId" -> {
          result.success(AppCenter.getInstallId().get()?.toString())
          return
        }
        "isCrashesEnabled" -> {
          result.success(Crashes.isEnabled().get())
          return
        }
        "configureCrashes" -> {
          val value = call.arguments as Boolean
          Crashes.setEnabled(value).get()
        }
        "isAnalyticsEnabled" -> {
          result.success(Analytics.isEnabled().get())
          return
        }
        "configureAnalytics" -> {
          val value = call.arguments as Boolean
          Analytics.setEnabled(value).get()
        }
        "generateTestCrash" -> {
          Crashes.generateTestCrash()
        }
        "trackError" -> {
          val message = call.argument<String>("message")
          val properties = call.argument<Map<String, String>>("properties")
          Crashes.trackError(Throwable(message), properties, null)
        }
        else -> {
          result.notImplemented()
        }
      }

      result.success(null)
    } catch (error: Exception) {
      Log.e("onMethodCall", methodChannelName, error)
      throw error
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    val activity = binding.activity
    application = activity.application
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
  }

}
