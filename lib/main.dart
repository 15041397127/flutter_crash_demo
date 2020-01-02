import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crash_plugin/flutter_crash_plugin.dart';
import 'dart:io';

bool get isInDebugMode{

  bool inDebugMode = false;

  assert(inDebugMode = true);
  return inDebugMode;

  

}

//上报数据至Bugly
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error:$error');

//  if (isInDebugMode) {
//    print(stackTrace);
//    print('In dev mode. Not sending report to Bugly.');
//    return;
//  }

  print('Reporting to Bugly...');

  FlutterCrashPlugin.postException(error, stackTrace);
}

Future<Null> main() async {
  //注册Flutter 框架的异常回调
  FlutterError.onError = (FlutterErrorDetails details) async {
    //转发至Zone的错误回调
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  //自定义错误提示页面
  ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
    return Scaffold(
      body: Center(
        child: Text("Custom Error Widgets"),
      ),
    );
  };

  //使用runZone方法将runApp 的运行放置在Zone 并提供统一的异常回调
  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    await _reportError(error, stackTrace);
  });
}

//void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    //由于Bugly将ios android分为两个独立的应用 因此需要使用不同的App ID进行初始化
    if (Platform.isAndroid) {
      FlutterCrashPlugin.setUp('66c4cec44f');
    } else if (Platform.isIOS) {
      FlutterCrashPlugin.setUp('816831dcd2');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Crashy')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text('Dart exception'),
                onPressed: () {
                  //触发同步异常
                  throw StateError('这是个Dart的同步异常');
                }),
            RaisedButton(
                child: Text('async Dart exception'),
                onPressed: () {
                  //触发异步异常
                  Future.delayed(Duration(seconds: 1)).then((e) {
                    throw StateError('这是个Dart 异步异常');
                  });
                }),
          ],
        ),
      ),
    );
  }
}
