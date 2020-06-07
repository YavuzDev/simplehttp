import 'dart:io';

import 'src/http_path_manager.dart';
import 'src/request.dart';
import 'src/response.dart';


typedef ResponseFunction = Function(Request request, Response response);

class SimpleHttp {
  final port;

  final HttpPathManager _httpPathManager = HttpPathManager();

  SimpleHttp({final this.port = 8080});

  void start() async {
    final server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      port,
    );

    await for (final HttpRequest request in server) {
      if (request.uri.path == '/favicon.ico') {
        await request.response.close();
        continue;
      }

      switch (request.method) {
        case 'GET':
          await _httpPathManager.handle(request, request.response, _httpPathManager.getRequests);
          break;
        case 'POST':
          await _httpPathManager.handle(request, request.response, _httpPathManager.postRequests);
          break;
        case 'PUT':
          await _httpPathManager.handle(request, request.response, _httpPathManager.putRequests);
          break;
        case 'DELETE':
          await _httpPathManager.handle(request, request.response, _httpPathManager.deleteRequests);
          break;
      }
      await request.response.close();
    }
  }

  void get(final path, final ResponseFunction responseFunction) {
    _httpPathManager.addGet(path, responseFunction);
  }

  void post(final path, final ResponseFunction responseFunction) {
    _httpPathManager.addPost(path, responseFunction);
  }

  void put(final path, final ResponseFunction responseFunction) {
    _httpPathManager.addPut(path, responseFunction);
  }

  void delete(final path, final ResponseFunction responseFunction) {
    _httpPathManager.addDelete(path, responseFunction);
  }
}
