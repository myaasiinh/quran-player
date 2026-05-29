import '/config/environment/config_data.dart';

/* author
   myaasiinh@gmail.com
*/
enum Environment { PRODUCTION, STAGING, DEVELOPMENT }

extension EnvExtension on Environment {
  bool get isStaging => this == Environment.STAGING;

  bool get isDev => this == Environment.DEVELOPMENT;

  bool get isProduction => this == Environment.PRODUCTION;
}

class AppEnv {
  static late ConfigData config;

  static Environment get env {
    const envStr = String.fromEnvironment('ENV', defaultValue: 'DEV');
    switch (envStr) {
      case 'PROD':
        return Environment.PRODUCTION;
      case 'STG':
        return Environment.STAGING;
      case 'DEV':
      default:
        return Environment.DEVELOPMENT;
    }
  }

  static void set({
    required Environment environment,
    required ConfigData configuration,
  }) {
    config = configuration;
  }
}
