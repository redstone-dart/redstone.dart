library bloodless_mocks;

import 'dart:io';
import 'dart:collection';
import 'dart:convert';
import 'dart:async';

import 'package:bloodless/server.dart';

part 'package:bloodless/src/http_mock.dart';

/**
 * A class to simulate requests in unit tests.
 * 
 * Usage:
 * 
 *     var req = new MockRequest("/service");
 *     app.dispatch(req).then((resp) {
 *       ...
 *     });
 */
class MockRequest implements Request {
  
  final String method;
  final Map<String, String> queryParams;
  final String bodyType;
  final dynamic body;
  
  HttpHeaders _headers;
  HttpResponse _response;
  HttpRequest _httpRequest;
  
  final HttpSession session;
  
  MockRequest(String uri, {String this.method: GET, 
              Map<String, String> this.queryParams: const {},
              String this.bodyType, dynamic this.body,
              Map<String, String> headers: const {},
              HttpSession this.session}) {
    
    var hValues = {};
    headers.forEach((k, v) => hValues[k] = [v]);
    _headers = new MockHttpHeaders(hValues);

    Uri uriObj = Uri.parse(uri);
    _httpRequest = new MockHttpRequest(uriObj, method, _headers);
    _response = _httpRequest.response;
    
  }
  
  HttpHeaders get headers => _headers;
  
  HttpResponse get response => _response;
  
  HttpRequest get httpRequest => _httpRequest;
  
}

/**
 * A mock session, intended to be used
 * with [MockRequest].
 * 
 * Usage:
 * 
 *     var session = new MockHttpSession("session_1", {"username": "user"});
 *     var req = new MockRequest("/service", session: session);
 *     app.dispatch(req).then((resp) {
 *       ...
 *     });
 *     
 */
class MockHttpSession implements HttpSession {
  
  final String id;
  final Map<String, String> _values = {};
  
  Function _timeoutCallback;
  bool _destroyed = false;
  
  MockHttpSession(String this.id, {Map<String, String> values}) {
    if (values != null) {
      _values.addAll(values);
    }
  }
  
  void destroy() {
    _destroyed = true;
  }
  
  bool get destroyed => _destroyed;
  
  void set onTimeout(void callback()) {
    _timeoutCallback = callback;
  }
  
  Function get timeoutCallback => _timeoutCallback;

  bool get isNew => false;
  
  set isNew(bool value) => isNew = value;
  
  operator [](Object key) => _values[key];
  
  operator []=(Object key, Object value) => _values[key] = value;
  
  bool containsValue(Object value) => _values.containsValue(value);

  bool containsKey(Object key) => _values.containsKey(key);

  Object putIfAbsent(Object key, Object ifAbsent()) => _values.putIfAbsent(key, ifAbsent);

  void addAll(Map other) => _values.addAll(other);

  Object remove(Object key) => _values.remove(key);

  void clear() => _values.clear();

  void forEach(void f(Object key, Object value)) => _values.forEach(f);

  Iterable get keys => _values.keys;

  Iterable get values => _values.values;

  int get length => _values.length;

  bool get isEmpty => _values.isEmpty;

  bool get isNotEmpty => _values.isNotEmpty;
  
}