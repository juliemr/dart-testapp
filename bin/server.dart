import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';

VirtualDirectory staticFiles = new VirtualDirectory('build/web');

void _serveRequest (HttpRequest request) {
  print(request.uri.path);
  if (request.uri.path == '/slowapi') {
    new Timer(const Duration(seconds: 2), () {
      request.response.write('finished');
      request.response.close();
    });
  } else {
    staticFiles.serveRequest(request);
  }
}

void main() {
  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8095).then((HttpServer server) {
    print('Server listening at port ${server.port}');
    server.listen(_serveRequest);
  });
}
