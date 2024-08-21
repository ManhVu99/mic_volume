package com.mic_volume.mic_volume
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.media.MediaRecorder
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
/** MicVolumePlugin */
class MicVolumePlugin: FlutterPlugin, MethodCallHandler,ActivityAware{
    private lateinit var channel: MethodChannel
    private var recorder: MediaRecorder? = null
    private var context: Context? = null
    private var activity: Activity? = null

    companion object {
        private const val PERMISSION_REQUEST_CODE = 1
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mic_volume")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getMicLevel" -> {
                val micLevel = getMicLevel()
                result.success(micLevel)
            }
            "startChecking" -> {
                if (checkPermission()) {
                    startRecording()
                    result.success(null)
                } else {
                    requestPermission()
                    result.error("PERMISSION_DENIED", "Microphone permission denied", null)
                }
            }
            "stopChecking" -> {
                stopRecording()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun checkPermission(): Boolean {
        return context?.let {
            ContextCompat.checkSelfPermission(it, android.Manifest.permission.RECORD_AUDIO)
        } == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermission() {
        activity?.let {
            ActivityCompat.requestPermissions(
                it,
                arrayOf(android.Manifest.permission.RECORD_AUDIO),
                PERMISSION_REQUEST_CODE
            )
        }
    }

    private fun startRecording() {
        
            recorder = MediaRecorder().apply {
                setAudioSource(MediaRecorder.AudioSource.MIC)
                setOutputFormat(MediaRecorder.OutputFormat.DEFAULT) // No need to set output file or encoder
                setAudioEncoder(MediaRecorder.AudioEncoder.DEFAULT)
                setOutputFile("/dev/null") // No recording, just checking levels
                prepare()
                start()
            }
    }

    private fun stopRecording() {
        recorder?.apply {
            stop()
            release()
        }
        recorder = null
    }

    private fun getMicLevel(): Double {
        return recorder?.maxAmplitude?.toDouble()?.div(32767) ?: 0.0
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
