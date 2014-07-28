import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'slow_component.dart' show SlowComponent;

slowRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
    'before': ngRoute(path: '/before', view: 'views/before.html'),
    'pending': ngRoute(path: '/pending', view: 'views/pending.html',
        enter: (RouteEnterEvent e) => router.go('finished', {})),
    'finished': ngRoute(path: '/finished', view: 'views/finished.html', preEnter: (RoutePreEnterEvent e) {
      Completer completer = new Completer();
      e.allowEnter(completer.future);
      new Timer(const Duration(seconds: 2), () => completer.complete(true));
    }),
    'default': ngRoute(defaultRoute: true, enter: (RouteEnterEvent e) => router.go('before', {}))
  });
}

class TestAppModule extends Module {
  TestAppModule() {
    bind(SlowComponent);
    value(RouteInitializerFn, slowRouteInitializer);
  }
}

void main() {
  applicationFactory()
      .addModule(new TestAppModule())
      .run();
}
