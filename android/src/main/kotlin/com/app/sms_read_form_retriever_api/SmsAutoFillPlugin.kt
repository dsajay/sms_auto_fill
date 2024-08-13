package com.app.sms_read_form_retriever_api
import android.content.IntentFilter
import android.widget.Toast
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

import android.os.Build

import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
/** SmsAutoFillPlugin */
class SmsAutoFillPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, ActivityResultListener  {
    companion object {
        const val REQUEST_CODE = 1001
    }
  private lateinit var channel : MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private var pendingResult: io.flutter.plugin.common.MethodChannel.Result? = null
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "sms_auto_fill")
    channel.setMethodCallHandler(this)
    context=flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: io.flutter.plugin.common.MethodChannel.Result) {
      pendingResult = result
      when (call.method) {
      "registerReceiver" -> {
          activity?.let{it->

              val intentFilter = IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION)
              if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                  // Android 12 and above
                  context.registerReceiver(smsVerificationReceiver, intentFilter,Context.RECEIVER_EXPORTED)
              } else {
                  // Android 11 and below
                  context.registerReceiver(smsVerificationReceiver, intentFilter)
              }

              SmsRetriever.getClient(it).startSmsUserConsent(null)

          }

      }
      "unregisterReceiver" -> {
          try {
              context.unregisterReceiver(smsVerificationReceiver)
          } catch (ex: Exception) {
              ex.printStackTrace()
          }
          result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
      try {
          context.unregisterReceiver(smsVerificationReceiver)
      } catch (ex: Exception) {
          ex.printStackTrace()
      }
      channel.setMethodCallHandler(null)
  }
    private val smsVerificationReceiver: BroadcastReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (SmsRetriever.SMS_RETRIEVED_ACTION.equals(intent.action)) {
            val extras = intent.extras
            val smsRetrieverStatus: Status? = extras!![SmsRetriever.EXTRA_STATUS] as Status?
            smsRetrieverStatus?.let{it->
            when (it.getStatusCode()) {
                CommonStatusCodes.SUCCESS -> {
                    // Get consent intent
                    val consentIntent = extras.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
                    try {
                        //Toast.makeText(context, " listening started",Toast.LENGTH_SHORT).show()
                        activity?.startActivityForResult(consentIntent, REQUEST_CODE)
                    } catch (e: ActivityNotFoundException) {
                        pendingResult?.success("ActivityNotFoundException ${e.message!!}")
                    }
                }

                CommonStatusCodes.TIMEOUT -> {
                    pendingResult?.success("TIMEOUT")
                }
                else ->{
                    pendingResult?.success("ELSE CASE")
                }
                 }


              }

            }
        }
    }
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {

        if (requestCode == REQUEST_CODE) {
            try {
                context.unregisterReceiver(smsVerificationReceiver)
            } catch (ex: Exception) {
                ex.printStackTrace()
            }
            if (resultCode == android.app.Activity.RESULT_OK) {
                val message: String? = data!!.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
                pendingResult?.success(message)
            }

            return true
        }
        return false
    }
}
