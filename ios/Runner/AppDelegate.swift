import Flutter
import UIKit
import GoogleMaps
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase FIRST, before any other services
    FirebaseApp.configure()
    
    // TODO: Replace YOUR_API_KEY with your actual Google Maps API key
    GMSServices.provideAPIKey("AIzaSyDt1MrDbkfhBEIkopSElGtH6COwbLRSW0o")
    
    // Register Flutter plugins AFTER Firebase is initialized
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
