import 'package:quran_player/config/network/api_token_manager.dart';

class ConfigData {
  ConfigData({
    required this.baseUrl,
    required this.tokenType,
    required this.clientToken,
    this.sslFingerprints = const [],
    this.enableSslPinning = false,
    this.maxRetry = 3,
  });

  String baseUrl;
  TokenType tokenType;
  String clientToken;
  List<String> sslFingerprints;
  bool enableSslPinning;
  int maxRetry;

  static final dev = ConfigData(
    baseUrl: 'https://api.alquran.cloud/v1',
    tokenType: TokenType.NONE,
    clientToken: '',
  );

  static final stg = ConfigData(
    baseUrl: 'https://api.alquran.cloud/v1',
    tokenType: TokenType.NONE,
    clientToken: '',
  );

  static final prod = ConfigData(
    baseUrl: 'https://api.alquran.cloud/v1',
    tokenType: TokenType.NONE,
    clientToken: '',
    enableSslPinning: true,
    sslFingerprints: [
      // Add Quran API SSL Fingerprints if needed
    ],
  );
}
