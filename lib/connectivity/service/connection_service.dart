import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as _http;

const google = "https://www.google.com";

class ConnectionService {
  Future<bool> isReachableNetwork() async {
    try {
      final res = await _http.head(Uri.parse(google));
      log("network done listening...");
      if (res.statusCode == HttpStatus.ok) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
