import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Sediakan Google Maps API key dari file .env (di-bundle sebagai asset Flutter),
    // sehingga key tetap berasal dari satu sumber (.env) tanpa di-hardcode.
    if let apiKey = readMapsApiKeyFromEnv(), !apiKey.isEmpty {
      GMSServices.provideAPIKey(apiKey)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  /// Membaca nilai MAPS_API_KEY dari file `.env` yang dibundel di flutter_assets.
  private func readMapsApiKeyFromEnv() -> String? {
    guard
      let path = Bundle.main.path(
        forResource: ".env", ofType: nil, inDirectory: "flutter_assets"),
      let contents = try? String(contentsOfFile: path, encoding: .utf8)
    else {
      return nil
    }

    for rawLine in contents.split(separator: "\n") {
      let line = rawLine.trimmingCharacters(in: .whitespaces)
      if line.hasPrefix("MAPS_API_KEY=") {
        return String(line.dropFirst("MAPS_API_KEY=".count))
          .trimmingCharacters(in: .whitespaces)
      }
    }
    return nil
  }
}
