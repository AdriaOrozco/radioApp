// ignore: depend_on_referenced_packages
import 'package:dart_ping/dart_ping.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
// ignore: depend_on_referenced_packages
import 'package:dns_client/dns_client.dart';
// ignore: implementation_imports
import 'package:radio_browser_flutter/src/services/implementations/index.dart';
// ignore: implementation_imports
import 'package:radio_browser_flutter/src/services/implementations/tag_service.dart';
// ignore: implementation_imports
import 'package:radio_browser_flutter/src/services/index.dart';

/// Radio Browser client instance
///
/// It must be initialized before being used, otherwise an error is thrown
///
/// Initialization:
/// ```dart
/// RadioBrowserClient.initialize(...)
/// ```
///
/// Usage:
///
/// final instance = RadioBrowserClient.instance;
class RadioBrowserClient {
  static Future<void> initialize(String userAgent) async {
    assert(!_instance._initialized, 'This instance is already initialized');
    await _instance._init(userAgent);
  
    _instance._initialized = true;
  }

  static RadioBrowserClient get instance {
    assert(_instance._initialized,
        'You must initialize Radio Browser client before accessing the instance');
    return _instance;
  }

  RadioBrowserClient._();
  static final RadioBrowserClient _instance = RadioBrowserClient._();

  bool _initialized = false;

  late CodecService codecs;

  late CountryService countries;

  late LanguageService languages;

  late ServerService servers;

  late TagService tags;

  late StationCheckService stationChecks;

  late StationService stations;

  String checkRadioUrl(String url) {
    if (!url.startsWith('http')) {
      return 'http://$url/';
    }
    return url;
  }

  Future<void> _init(String userAgent) async {
    final baseUrl = await _fetchBaseUrl();
    final dio = Dio(
      BaseOptions(
        baseUrl: checkRadioUrl(baseUrl),
        headers: {
          "User-Agent": userAgent,
        },
      ),
    );

    codecs = CodecServiceImpl(dio: dio);

    countries = CountryServiceImpl(dio: dio);

    languages = LanguageServiceImpl(dio: dio);

    servers = ServerServiceImpl(dio: dio);

    tags = TagServiceImpl(dio: dio);

    stationChecks = StationCheckServiceImpl(dio: dio);

    stations = StationServiceImpl(dio: dio);
  }

  Future<String> _fetchBaseUrl() async {
    const baseUrl = 'all.api.radio-browser.info';
    final dns = DnsOverHttps.google();
    final ipAddresses = await dns.lookup(baseUrl);
    var searchUrl = 'de1.api.radio-browser.info';
    var lastRoundTripTime = 0x7fffffffffffffff;

    /// Loop through the ipAddresses to find the fastest one
    for (var ipAddress in ipAddresses) {
      final ping = Ping(ipAddress.address, count: 1);
      final future = await ping.stream.first;
      final timeTaken = _getResponseTime(future);
      if (timeTaken < lastRoundTripTime) {
        lastRoundTripTime = timeTaken;
        searchUrl = ipAddress.address;
      }
    }
    dns.close(force: true);
    return searchUrl;
  }

  int _getResponseTime(PingData pingData) {
    if (pingData.response != null) {
      return pingData.response!.time!.inMicroseconds;
    }
    return pingData.summary!.time!.inMicroseconds;
  }
}
