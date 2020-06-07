import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Request {
  final HttpRequest _httpRequest;

  Request(this._httpRequest);

  HttpHeaders headers() {
    return _httpRequest.headers;
  }

  HttpConnectionInfo info() {
    return _httpRequest.connectionInfo;
  }

  HttpSession session() {
    return _httpRequest.session;
  }

  Future<Map<String, dynamic>> body() async {
    final value = await _httpRequest.transform(utf8.decoder.cast());

    final list = await value.toList();

    final regex = RegExp(r'name="(.*)"\s*(.*)');
    final map = <String, dynamic>{};

    try {
      final match = regex.allMatches(list[0]);

      for (var i = 0; i < match.length; i++) {
        final groups = match.elementAt(i);

        map[groups.group(1)] = groups.group(2);
      }
      return map;
    } catch (_) {}
    return map;
  }

  List<Cookie> cookies() {
    return _httpRequest.cookies;
  }

  List<String> segments() {
    return _httpRequest.uri.pathSegments;
  }
}
