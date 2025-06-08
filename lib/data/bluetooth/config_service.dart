import 'package:safe_ride_app/data/model/device_config.dart';

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() => _instance;

  ConfigService._internal();

  DeviceConfig _config = DeviceConfig();

  DeviceConfig get config => _config;

  void updateConfig(Function(DeviceConfig) updateFn) {
    updateFn(_config);
  }

  void reset() {
    _config = DeviceConfig();
  }
}
