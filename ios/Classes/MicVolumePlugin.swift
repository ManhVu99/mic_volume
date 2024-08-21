import Flutter
import UIKit
import AVFoundation

public class MicVolumePlugin: NSObject, FlutterPlugin {
  private var recorder: AVAudioRecorder?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mic_volume", binaryMessenger: registrar.messenger())
    let instance = MicVolumePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     switch call.method {
        case "getMicLevel":
            result(getMicLevel())
        case "startChecking":
            checkPermission { granted in
                if granted {
                    self.startRecording()
                    result(nil)
                } else {
                    result(FlutterError(code: "PERMISSION_DENIED", message: "Microphone permission denied", details: nil))
                }
            }
        case "stopChecking":
            stopRecording()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
       }
    }
     private func checkPermission(completion: @escaping (Bool) -> Void) {
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                completion(granted)
            }
        default:
            completion(false)
        }
    }

    private func startRecording() {
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue
        ]
        do {
            let url = URL(fileURLWithPath: "/dev/null")
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorder?.record()
        } catch {
            print("Failed to start recording: \(error)")
        }
    }

    private func stopRecording() {
        recorder?.stop()
        recorder = nil
    }

    private func getMicLevel() -> Double {
        recorder?.updateMeters()
        let averagePower = Double(recorder?.averagePower(forChannel: 0) ?? -160)
        let volume = Double(floatLiteral: pow(10.0, averagePower / 20.0))
        return volume
    }
}
