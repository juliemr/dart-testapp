import 'dart:async';
import 'dart:io';
import 'package:http_server/http_server.dart';

VirtualDirectory staticFiles = new VirtualDirectory('build/web')
  ..followLinks = true
  ..jailRoot = false
  ..allowDirectoryListing = true;

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

  // All the Process calls here are a hack to fix up the build folder so that it
  // can serve Dart as well as JavaScript.
  Process.run('rsync', ['-rl', '--exclude', 'package', 'web/', 'build/web']).then((ProcessResult results) {
    Process.run('rm', ['-rf', 'build/web/packages']).then((ProcessResult results) {
      Process.run('ln', ['-s', Directory.current.path + '/packages', 'build/web/packages']).then((ProcessResult results) {
        Process.run('ln', ['-s', Directory.current.path + '/lib', 'build/web/packages/testapp']).then((ProcessResult results) {
          HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8095).then((HttpServer server) {
            print('Server listening at port ${server.port}');
            server.listen(_serveRequest);
          });
        });
      });
    });
  });
}
