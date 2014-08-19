library slow_component;

import 'dart:async';

import 'package:angular/angular.dart';

String _NOT_STARTED = 'not started';
String _PENDING = 'pending';
String _FINISHED = 'finished';

@Component(
    selector: 'slowstuff',
    templateUrl: 'slow_component.html'
)
class SlowComponent {
  final String slow;
  final Http _http;
  final NgRoutingHelper _routeHelper;
  
  String slowHttpStatus = _NOT_STARTED;
  String slowFunctionStatus = _NOT_STARTED;
  String slowTimerStatus = _NOT_STARTED;
  String slowViewStatus = _NOT_STARTED;
  
  SlowComponent(this._http, this._routeHelper) {
    slow = this;
  }
  
  void slowHttp() {
    slowHttpStatus = _PENDING;
    _http.get('/slowapi')
        .then((HttpResponse res) => slowHttpStatus = res.responseText)
        .catchError((e) => slowHttpStatus = 'failed');
  }
  
  void slowTimer() {
    slowTimerStatus = _PENDING;
    new Timer(const Duration(seconds: 2), () {
      slowTimerStatus = _FINISHED;
    });
  }
  
  void slowFunction() {
    slowFunctionStatus = _PENDING;
    for (num i = 0, t = 0; i < 1000000000; ++i) {
      t++;
    }
    slowFunctionStatus = _FINISHED;
  }
  
  void slowView() {
    _routeHelper.router.go('pending', {});
  }
}
