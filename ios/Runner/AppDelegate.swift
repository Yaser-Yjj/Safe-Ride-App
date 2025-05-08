import Flutter
import UIKit
import GoogleMaps

GMSServices.provideAPIKey("AIzaSyBKDgdOPEklcegOSK4vjVfsIg4npasX1xw")

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
