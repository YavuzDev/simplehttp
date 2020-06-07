import 'dart:io';


import '../simplehttp.dart';
import 'request.dart';
import 'response.dart';

class HttpPathManager {
  final Map<String, ResponseFunction> _getRequests = {};

  final Map<String, ResponseFunction> _postRequests = {};

  final Map<String, ResponseFunction> _putRequests = {};

  final Map<String, ResponseFunction> _deleteRequests = {};

  void handle(final HttpRequest request, final HttpResponse response, Map<String, ResponseFunction> available) async {
    final function = _correctRequest(request.uri.path, available);
    if (function == null) {
      return;
    }
    await function.call(Request(request), Response(request.response));
  }

  void addGet(final path, final ResponseFunction responseFunction) {
    _getRequests[path] = responseFunction;
  }

  void addPost(final path, final ResponseFunction responseFunction) {
    _postRequests[path] = responseFunction;
  }

  void addPut(final path, final ResponseFunction responseFunction) {
    _postRequests[path] = responseFunction;
  }

  void addDelete(final path, final ResponseFunction responseFunction) {
    _postRequests[path] = responseFunction;
  }

  ResponseFunction _correctRequest(
      final String url, final Map<String, ResponseFunction> requests) {
    final pathStored = _getRequests[url];

    if (pathStored != null) {
      return pathStored;
    }

    final splitUrl = url.split('/');

    for (final key in _getRequests.keys) {
      final split = key.split('/');
      var correct = true;

      if (split.length == splitUrl.length) {

        for (var i = 0; i < split.length; i++) {
          if (split[i].contains(':')) {
            continue;
          }

          if (split[i] != splitUrl[i]) {
            correct = false;
            break;
          }
        }

        return correct ? _getRequests[key] : null;
      }
    }

    return null;
  }

  Map<String, ResponseFunction> get deleteRequests => _deleteRequests;

  Map<String, ResponseFunction> get putRequests => _putRequests;

  Map<String, ResponseFunction> get postRequests => _postRequests;

  Map<String, ResponseFunction> get getRequests => _getRequests;
}
