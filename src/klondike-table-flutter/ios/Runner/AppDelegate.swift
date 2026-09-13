import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var hostChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "klondike/host",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "filesDir":
        let urls = FileManager.default.urls(
          for: .applicationSupportDirectory,
          in: .userDomainMask
        )
        let dir = urls[0]
        try? FileManager.default.createDirectory(
          at: dir,
          withIntermediateDirectories: true
        )
        result(dir.path)
      case "open":
        guard let urlString = call.arguments as? String,
              let url = URL(string: urlString)
        else {
          result(
            FlutterError(code: "open", message: "bad url", details: nil)
          )
          return
        }
        UIApplication.shared.open(url)
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    hostChannel = channel
  }
}
