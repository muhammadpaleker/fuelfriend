import Flutter
import UIKit
// Required to provide the native iOS Google Maps API key
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Provide your iOS Google Maps API key here. Replace the placeholder
    // value with your actual API key from Google Cloud Console. Do NOT commit
    // a production key to source control; consider using environment
    // configuration or secure storage.
    GMSServices.provideAPIKey("YOUR_IOS_GOOGLE_MAPS_API_KEY_HERE")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
