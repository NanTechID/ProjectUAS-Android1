import 'dart:io';

/// Returns the correct base URL for the API depending on the platform.
///
/// - Android emulators use 10.0.2.2 to reach the host machine.
/// - Other platforms (iOS simulator, desktop) can use localhost.
String apiBaseUrl() {
  // Use emulator-safe host for Android and include the project API base path
  if (Platform.isAndroid) {
    return 'http://10.0.2.2/api_apotek-main';
  }
  return 'http://localhost/api_apotek-main';
}
