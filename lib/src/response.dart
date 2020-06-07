
import 'dart:convert';
import 'dart:io';

class Response {

  final HttpResponse _httpResponse;

  Response(this._httpResponse);

  Response json(final json) {
    _httpResponse.headers.contentType = ContentType.json;

    if (json.runtimeType != String) {
      _httpResponse.write(jsonEncode(json));
      return this;
    }
    _httpResponse.write(json);
    return this;
  }

  Response status(final int status) {
    _httpResponse.statusCode = status;
    return this;
  }

  Response header(final String name, final Object value) {
    _httpResponse.headers.add(name, value);
    return this;
  }
}