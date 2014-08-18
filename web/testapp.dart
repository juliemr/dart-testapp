import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';
import 'package:testapp/slow_component.dart' show SlowComponent;

slowRouteInitializer(Router router, RouteViewFactory views) {
  views.configure({
    'before': ngRoute(path: '/before', view: 'packages/testapp/views/before.html'),
    'pending': ngRoute(path: '/pending', view: 'packages/testapp/views/pending.html',
        enter: (RouteEnterEvent e) => router.go('finished', {})),
    'finished': ngRoute(path: '/finished', view: 'packages/testapp/views/finished.html', preEnter: (RoutePreEnterEvent e) {
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
    bind(RouteInitializerFn, toValue: slowRouteInitializer);
    bind(NgRoutingUsePushState,
            toValue: new NgRoutingUsePushState.value(false));
  }
}

void main() {
  applicationFactory()
      .addModule(new TestAppModule())
      .run();
}
