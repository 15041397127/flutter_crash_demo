package zhangxu.com.flutter_crash_demo;

import android.os.Bundle;
import android.support.annotation.NonNull;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

//public class MainActivity extends FlutterActivity {
////  @Override
////  protected void onCreate(Bundle savedInstanceState) {
////    super.onCreate(savedInstanceState);
////    GeneratedPluginRegistrant.registerWith(this);
////  }
////}

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
  }
}