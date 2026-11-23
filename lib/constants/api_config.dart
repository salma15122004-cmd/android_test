/// Where the backend (PHP on XAMPP) can be reached from the app.
abstract final class ApiConfig {
  /// The address of the computer that runs XAMPP.
  ///
  /// - Android emulator: `10.0.2.2`
  /// - Real phone: the IPv4 address of the computer (run `ipconfig` in a
  ///   terminal). The phone must be on the same Wi-Fi network.
  static const String host = '127.0.0.1:8080';

  /// The folder inside `htdocs` that contains the `register` and `config`
  /// folders of the backend.
  static const String projectFolder = 'childtherapy';

  static const String baseUrl = 'http://$host/$projectFolder';
}
